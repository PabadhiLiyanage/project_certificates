import ballerina/io;
import ballerina/jballerina.java;
import ballerina/random;
import ballerinax/aws.s3;
import ballerinax/googleapis.sheets as gsheets;

configurable string accessKeyId = ?;
configurable string secretAccessKey = ?;
configurable string region = ?;
configurable string bucketName = ?;
configurable string pdfFilePath = ?;
configurable string font_type = ?;
configurable int fontsize = ?;
configurable int centerY = ?;
configurable int centerX = ?;
configurable boolean geturl = ?;
configurable string fontFilePath = ?;
configurable string certificate_date = ?;
configurable string certification_name = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string spreadsheetId = ?;
configurable string sheetName = ?;


gsheets:Client spreadsheetClient = check new ({
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        refreshUrl
    }
});

public function main() returns error? {
    error? err = certicateGeneration(pdfFilePath, font_type, fontsize, centerY, centerX, geturl, fontFilePath);
}

public function PDFGenerator(handle inputFilePath, handle replacement, handle font_type, int fontsize, int centerX, int centerY, handle fontFilePath, handle outputFileName) = @java:Method {
    'class: "org.PDFCreator.PDFGenerator",
    name: "pdf"
} external;

public function AWSHandler(string file_path, string file_name) returns string|error? {
    s3:ConnectionConfig amazonS3Config = {
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        region: region
    };

    s3:Client amazonS3Client = check new (amazonS3Config);
    byte[] outputpdfbytes = check io:fileReadBytes(file_path);
    error? createObjectResponse = amazonS3Client->createObject(bucketName, file_name, outputpdfbytes, "public-read");
    string url = "https://" + bucketName + ".s3." + region + ".amazonaws.com/" + file_name;
    return url;
}

public function certicateGeneration(string inputFilePath, string font_type, int fontsize, int centerY, int centerX, boolean geturl, string fontFilePath) returns error? {
    gsheets:Column col = check spreadsheetClient->getColumn(spreadsheetId, sheetName, "E");
    int i = 1;
    string outputSpreadSheetID = "";
    if geturl {
        string|error? output = createNeworkBook();
        if output is string {
            outputSpreadSheetID = output;
        }
    }
    while i < col.values.length() {
        string|error? checkID = createCheckID();
        string replacement = col.values[i].toString();
        string file_name;
        string id = "";
        if checkID is string {
            file_name = replacement + checkID + ".pdf";
            id = checkID;
        }
        else {
            file_name = replacement + ".pdf";
        }

        string file_path = "outputs/" + file_name;
        handle javastrName = java:fromString(replacement);
        handle javafont_type = java:fromString(font_type);
        handle javafontPath = java:fromString(fontFilePath);
        handle pdfpath = java:fromString(inputFilePath);
        handle javaOurputfileName = java:fromString(file_name);
        PDFGenerator(pdfpath, javastrName, javafont_type, fontsize, centerX, centerY, javafontPath, javaOurputfileName);
        if geturl {
            gsheets:Column names = check spreadsheetClient->getColumn(spreadsheetId, sheetName, "A");
            string|error? url = AWSHandler(file_path, file_name);
            string name = names.values[i].toString();
            io:print(name);
            if url is string {
                string[] rowValues = [id, name, certification_name, certificate_date, url];
                _ = check spreadsheetClient->createOrUpdateRow(outputSpreadSheetID, "Sheet1", i + 1, rowValues);
            }
            else {
                io:print(url);
            }
        }
        i += 1;
    }
}

public function createCheckID() returns string|error? {
    int mainBody = check random:createIntInRange(111000, 999999);
    int subBody = check random:createIntInRange(101, 999);
    string mainstr = mainBody.toString();
    string subBodystr = subBody.toString();
    string checkID = mainstr + "_balc_" + subBodystr;
    return checkID;
}

public function createNeworkBook() returns string|error? {
    string spreadsheetId = "";
    string sheetName = "Sheet1";
    gsheets:Spreadsheet response = check spreadsheetClient->createSpreadsheet("Workbook_with_urls");
    spreadsheetId = response.spreadsheetId;
    string[] titles = ["credintial id", "name", "certification name", "certification date", "url"];
    _ = check spreadsheetClient->createOrUpdateRow(spreadsheetId, sheetName, 1, titles);
    return spreadsheetId;
}
