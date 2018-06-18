component {

    property name="injector" inject="wirebox";
    property name="log" inject="logbox:logger:{this}";

    public FileUploadService function init() {
        return this;
    }

    public File function processUpload(required string field) {
        var file = variables.injector.getInstance("file@FileUploadHelper");
        var tempPath = getTempPath();
        var result = fileUpload(tempPath, arguments.field);

        if (variables.log.canDebug()) {
            variables.log.debug("Received upload; name:'#result.serverfile#'; size:#result.filesize#");
        }

        file.setPath(tempPath & result.serverfile);
        return file;
    }

    public string function getTempPath() {
        var tempDir = replace(getTempDirectory(), "\", "/", "all") & "file-upload-helper-" & lcase(createUUID()) & "/";

        directoryCreate(tempDir);
        return tempDir;
    }

}