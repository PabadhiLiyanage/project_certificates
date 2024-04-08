# Certificate Generation Project

## Introduction
This Ballerina project automates the generation of certificates by utilizing a PDF template. It interacts with a Google Sheet to retrieve names for inclusion in the certificates. The generated PDFs can be stored locally within the project directory and uploaded to an Amazon S3 bucket, with the option to retrieve the URL for each uploaded certificate. Additionally, applicant details can be stored in a new Google Sheet for record-keeping and tracking purposes.

## Setup Guide

### Part 1: Google Sheets API Integration Setup
1. **Create a Google Cloud Platform project**
2. **Enable Google Sheets API**
3. **Configure OAuth Consent App**
4. **Generate OAuth Client ID and Client Secret**
5. **Obtain Access and Refresh Tokens using the OAuth 2.0 Playground**

For detailed instructions and further information, refer to the [Ballerina Google Sheets Connector README](https://github.com/ballerina-platform/module-ballerinax-googleapis.sheets?tab=readme-ov-file).

After obtaining the **clientId**, **clientSecret**, **refreshToken**, and **refreshUrl** for Google Sheets API integration, the next step is to obtain the **spreadsheetID** and **sheet name** of the Google Sheet that contains the list of names.

### Part 2: AWS S3 Bucket Initialization

To initialize AWS S3 bucket integration, follow these steps:

1. **Create an AWS Account**:
   - Sign up for an AWS account at the AWS website (https://aws.amazon.com/).

2. **Obtain Access Key ID and Secret Access Key**:
   - In the AWS Management Console, go to IAM (Identity and Access Management).
   - Create or use an existing IAM user and generate an access key ID and secret access key for programmatic access.

3. **Create an Amazon S3 Bucket**:
   - Navigate to the Amazon S3 service in the AWS Management Console.
   - Create a new bucket and configure its settings as needed.

4. **Grant Read-Only Access to Objects in the Bucket**:
   - Set up an IAM policy that grants read-only access to the S3 bucket.
   - Attach this policy to the IAM user or role that will access the bucket.

For detailed instructions and further information, refer to the AWS S3 documentation (https://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html).

## Configuration

To configure the behavior and customization of the certificate generation process in your Ballerina project, you need to create a `Config.toml` file under the `ballerina` directory in your project. This file contains essential settings. Here's what each key in the `Config.toml` file represents:

### Required Fields:

- **`certificate_date`**: Specifies the date for certificate generation.
- **`certification_name`**: Defines the name or title of the certification.
- **`accessKeyId`**: Your AWS S3 Access Key ID (for storing certificates).
- **`secretAccessKey`**: Your AWS S3 Secret Access Key (for storing certificates).
- **`region`**: Specifies the AWS region where your S3 bucket is located.
- **`bucketName`**: The name of your AWS S3 bucket where certificates will be stored.
- **`pdfFilePath`**: File path to the PDF template used for certificate generation.
- **`font_type`**: Specifies the type of font to be applied to the certificate text.
- **`fontsize`**: Sets the font size for the certificate text.
- **`centerX`**: Defines the X-coordinate for centering text on the certificate. Use a negative number if the center is the center of the page.
- **`centerY`**: Specifies the Y-coordinate for centering text on the certificate.
- **`geturl`**: A boolean flag indicating whether to obtain the URL after storing.
- **`fontFilePath`**: Specifies the file path to the font file. If using a custom font, provide the path to the .ttf file. If not using a custom font, leave this field empty (`fontFilePath = ""`).
- **`clientId`**: Your Google OAuth Client ID obtained during OAuth configuration.
- **`clientSecret`**: Your Google OAuth Client Secret obtained during OAuth configuration.
- **`refreshToken`**: Your Google OAuth Refresh Token used for authentication.
- **`refreshUrl`**: The URL for refreshing the Google OAuth token.
- **`sheetName`**: The name of the Google Sheets worksheet containing the names list.
- **`spreadsheetId`**: The ID of the Google Sheets spreadsheet containing the names list.

### Font Types:

For the `font_type` key, you can choose from the following font types:

- `TIMES_ROMAN`
- `TIMES_BOLD`
- `TIMES_ITALIC`
- `TIMES_BOLD_ITALIC`
- `HELVETICA`
- `HELVETICA_BOLD`
- `HELVETICA_OBLIQUE`
- `HELVETICA_BOLD_OBLIQUE`
- `COURIER`
- `COURIER_BOLD`
- `COURIER_OBLIQUE`
- `COURIER_BOLD_OBLIQUE`
- `SYMBOL`
- `ZAPF_DINGBATS`
- `CUSTOM` (for custom font types)

### Custom Font:

If you choose `CUSTOM` for `font_type`, provide the path to the custom font file using the `fontFilePath` key. Ensure the font file is in TrueType Font (TTF) format.

- **`fontFilePath`**: Path to the custom font file (TTF format).
If you are not using a custom font, leave `fontFilePath` empty (`fontFilePath = ""`).

---

This configuration file allows you to customize various aspects of the certificate generation process, including date, font style, AWS S3 storage, and PDF template path. Adjust these values according to your project's requirements.

