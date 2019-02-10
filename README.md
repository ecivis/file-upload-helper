# File Upload Helper

This is a ColdBox Module to simplify and standardize the process of receiving file uploads.
Support was added in 1.1.0 to receive file uploads as encoded data in a payload. This makes it possible to configure tests with a request body that includes the file content as a big string, rather than require the testing framework to make traditional multipart POSTs or have access to a filesystem stocked with test files.

## Requirements

- Lucee 5.2.8+ or Adobe ColdFusion 11+
- ColdBox 4.3+
- Java 8+
- Apache Commons Codec 1.9+ (provided by modern CFML engines)

## Installation

Install using [CommandBox](https://www.ortussolutions.com/products/commandbox):
`box install file-upload-helper`

## Usage

Get a reference to the `FileUploadService` in your handler, for example:
```
property name="fileUploadService" inject="fileUploadService@FileUploadHelper";
```

### Traditional File Upload
When a file is POSTed to your application using multipart/form-data, use the service to retrieve it from the request body:
```
var uploadedFile = variables.fileUploadService.processUpload("aFileFormField");
```

### Alternative File Upload
A client (a browser or a testing framework) may upload a file where the content is part of a structured payload. Consider a POST where the content-type is `application/json` and the raw body looks like the following:
```
{
	"inElement": false,
	"filename": "donny.html",
	"filedata": "PCFkb2N0eXBlIGh0bWw+CjxodG1sPgo8aGVhZD4KCTx0aXRsZT5Eb25ueTwvdGl0bGU+CjwvaGVhZD4KPGJvZHk+Cgk8aDE+RG9ubnk8L2gxPgoJPHA+RG9ubnkgd2FzIGEgZ29vZCBib3dsZXIsIGFuZCBhIGdvb2QgbWFuLiBIZSB3YXMgb25lIG9mIHVzLjwvcD4KPC9ib2R5Pgo8L2h0bWw+Cgo=",
	"commitTo": "Bosom of the Pacific Ocean"
}
```

When that sample content is received, it can be processed with `FileUploadService` to product a `File` in the same way as `processUpload()` above.
```
var payload = deserializeJson(getHttpRequestData().content);
var uploadedFile = variables.fileUploadService.processUploadAsData(payload.filename, payload.filedata);
```

### Returned File

These are the public methods from `File` that are now available:

| Method | Description |
|--------|-------------|
| getPath() | Returns the full filesystem path to the file. |
| getName() | Returns the filename, as provided in the request body. |
| getExtension() | Returns the file extension, as provided in the request body. |
| getContentType() | Returns the content type of the file based solely on the file extension. A modest number of popular content types are known; the default is application/octet-stream. |
| getSize() | Returns the number of bytes used by the file. |
| getFormattedSize() | Returns a string like "25.1 Kb" or "10.2 Mb" representing the file size (1 Kb = 1024 bytes). |
| getHash([algorithm:string]) | By default, returns the SHA-2 256-bit digest of the uploaded file. Specify SHA-1 if needed. |
| exists() | Returns a boolean indicating if the CFML engine thinks the file really exists. |
| delete() | Use this method to remove the file from the filesystem when it's no longer needed. |

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (MIT).
