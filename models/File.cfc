component {

    property name="contentTypeUtility" inject="contentTypeUtility@FileUploadHelper";

    public File function init(string path) {
        if (structKeyExists(arguments, "path") && arguments.path.len() != 0) {
            setPath(arguments.path);
        }
        return this;
    }

    public boolean function exists() {
        if (!structKeyExists(variables, "path") || isNull(variables.path) || variables.path.len() == 0) {
            return false;
        }
        return fileExists(variables.path);
    }

    public void function delete() {
        getNativeObject().delete();
    }

    public string function getPath() {
        if (!structKeyExists(variables, "path") || isNull(variables.path) || variables.path.len() == 0) {
            throw(type="UndefinedPropertyException", message="The path property is not yet defined.");
        }
        return variables.path;
    }

    /**
    * @path An actual file on the filesystem doesn't need to exist yet. It could be the path of the file that will eventually exist.
    */
    public void function setPath(required string path) {
        if (arguments.path.len() == 0) {
            throw(type="InvalidArgumentException", message="The path argument must not be zero length.");
        }
        variables.path = normalizePath(arguments.path);
        if (variables.path.left(1) != "/") {
            throw(type="InvalidArgumentException", message="The path argument should be absolute.");
        }
        variables.name = reReplace(variables.path, ".*/([^/]+)$", "\1");
        variables.extension = reReplaceNoCase(variables.name, ".*\.([a-z0-9]+)$", "\1");
    }

    public string function getName() {
        if (structKeyExists(variables, "name")) {
            return variables.name;
        }
        throw(type="UndefinedPropertyException", message="The name property is not yet defined.");
    }

    public numeric function getSize() {
        if (exists()) {
            return getNativeObject().length();
        }
        throw(type="FileDoesNotExistException", message="The size property is not known; the file does not exist.");
    }

    public string function getFormattedSize() {
        var bytes = getSize();
        var result = "";

        if (bytes < 1024) {
            result = bytes & " bytes";
        } else if (bytes < 1048576) {
            result = numberFormat((bytes / 1024), "9.9") & " Kb";
        } else if (bytes < 1073741824) {
            result = numberFormat((bytes / 1048576), "9.9") & " Mb";
        } else {
            result = numberFormat((bytes / 1073741824), "9.9") & " Gb";
        }
        return result;
    }

    public string function getExtension() {
        if (structKeyExists(variables, "extension")) {
            return variables.extension;
        }
        throw(type="UndefinedPropertyException", message="The extension property is not yet defined.");
    }

    public string function getContentType() {
        return variables.contentTypeUtility.getContentTypeByExtension(getExtension());
    }

    public string function getHash(string algorithm="sha256") {
        var du = createObject("java", "org.apache.commons.codec.digest.DigestUtils");

        if (!exists()) {
            throw(type="FileDoesNotExistException", message="A hash cannot be computed on a file that does not exist.");
        }

        if (arguments.algorithm == "sha256") {
            return lcase(du.sha256Hex(createObject("java", "java.io.FileInputStream").init(getNativeObject())));
        } else if (arguments.algorithm == "sha" || arguments.algorithm == "sha1") {
            return lcase(du.shaHex(createObject("java", "java.io.FileInputStream").init(getNativeObject())));
        }
        throw(type="UnsupportedAlgorithmException", message="The algorithm specified ('#arguments.algorithm#') is not supported.");
    }

    public any function getNativeObject() {
        if (exists()) {
            return createObject("java", "java.io.File").init(variables.path);
        }
        return createObject("java", "java.io.File");
    }

    public string function normalizePath(required string path) {
        return replace(arguments.path, "\", "/", "all");
    }

}
