component {

    property name="injector" inject="wirebox";
    property name="log" inject="logbox:logger:{this}";

    public FileUploadService function init() {
        return this;
    }

    /**
    * This processes a traditional upload using multipart/form-data
    * @field The form field name used in CFML to access the upload information
    */
    public File function processUpload(required string field) {
        var file = variables.injector.getInstance("file@FileUploadHelper");
        var tempPath = getTempPath();
        var result = fileUpload(tempPath, field);

        if (variables.log.canDebug()) {
            variables.log.debug("Received upload; name:'#result.serverfile#'; size:#result.filesize#");
        }

        file.setPath(tempPath & result.serverfile);
        return file;
    }

    /**
    * This processes an upload received in an alternative method, such as within a JSON payload
    * @filename The desired file name for the upload
    * @filedata The content of the file in Base64
    */
    public File function processUploadAsData(required string filename, required string filedata) {
        var file = variables.injector.getInstance("file@FileUploadHelper");
        var tempPath = getTempPath();

        fileWrite(tempPath & filename, binaryDecode(filedata, "base64"));
        file.setPath(tempPath & filename);

        if (variables.log.canDebug()) {
            variables.log.debug("Received upload; name:'#file.getName()#'; size:#file.getSize()#");
        }

        return file;
    }

    public string function getTempPath() {
        var tempDir = replace(getTempDirectory(), "\", "/", "all") & "file-upload-helper-" & lcase(createUUID()) & "/";

        directoryCreate(tempDir);
        return tempDir;
    }

}