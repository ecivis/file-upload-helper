component {

    public string function getContentTypeByExtension(required string extension, string default) {
        var ct = getContentTypes();

        if (structKeyExists(ct, arguments.extension)) {
            return ct[arguments.extension];
        }
        if (structKeyExists(arguments, "default")) {
            return arguments.default;
        }
        return "application/octet-stream";
    }

    public string function getContentTypeByPath(required string path, string default) {
        var extension = reReplaceNoCase(arguments.path, ".+\.([a-z]+)$", "\1");

        if (structKeyExists(arguments, "default")) {
            return getContentTypeByExtension(extension, arguments.default);
        }
        return getContentTypeByExtension(extension);
    }

    private struct function getContentTypes() {
        if (structKeyExists(variables, "contentTypes")) {
            return variables.contentTypes;
        }

        variables.contentTypes = {
            "doc": "application/msword",
            "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "dot": "application/msword",
            "dotx": "application/vnd.openxmlformats-officedocument.wordprocessingml.template",
            "gif": "image/gif",
            "htm": "text/html",
            "html": "text/html",
            "jar": "application/java-archive",
            "js": "application/javascript",
            "json": "application/json",
            "jpg": "image/jpeg",
            "jpeg": "image/jpeg",
            "pdf": "application/pdf",
            "ppt": "application/vnd.ms-powerpoint",
            "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
            "png": "image/png",
            "rtf": "application/rtf",
            "txt": "text/plain",
            "xfd": "application/vnd.xfdl",
            "xfdl": "application/vnd.xfdl",
            "xls": "application/vnd.ms-excel",
            "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "xlt": "application/vnd.ms-excel",
            "xltx": "application/vnd.openxmlformats-officedocument.spreadsheetml.template",
            "zip": "application/zip"
        };
        return variables.contentTypes;
    }

}