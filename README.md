# File Upload Helper

This is a ColdBox module to simplify and standardize the process of receiving file uploads.

## Requirements

- Lucee 5+ or Adobe ColdFusion 11+
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

When a file is POSTed to your application, use the service to retrieve it from the request body:
```
var uploadedFile = variables.fileUploadService.processUpload("aFileFormField");
```

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
