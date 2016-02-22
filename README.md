# Askme-Assignment
#Introduction

The purpose is to test the API's on the website https://data.gov.in. All the operations like filter,sorting etc are to be tested.
The solution is a R Script which contains the testcases to be executed, it calls the API with different parameters to ensure that the API is working properly.
Currently only Functional TestCases have been identified.
Negative testing for the API's and Performance testing can also be done.

#Hurdles in documentation
1. Documentation should also include steps for generation of API key for accessing the API's.
    The steps are:    
    a. Register on the website data.gov.in.
    b. Login and generate the API key which is used for all the queries.

2. The join request parameter example is not given, how to use it is not clear.

#How to Run the Code.
1. Code is written in R. The script file is test_api.R, you can install r from cran repository
   Windows:
   https://cran.r-project.org/bin/windows/base/ 
   Mac:
   https://cran.r-project.org/bin/macosx/

2. You can also install RStudio, easy working environment for R.
3. Libraries to be installed are RCurl and XML. 
   e.g. install.packages("RCurl")
4. Method and Base libraries are installed by default.
5. Run the testapi.R by the command "R < test_api.R --save", or any other command suitable.
6. The output is created in text_file.txt
7. The code is written in R version 3.1.1

#Interpreting the result
1. The output file text_file.txt contains the result of the testcases execution.
2. The testcases included are on field selection,filter selection,offset,sorting,limit
3. The output file contains a brief description of testcase for e.g.
   output "TestCase 1  filters id 1 PASSED" means the TestCase number is 1. Testcase is of Filters using the field "id" and 1st value has PASSED
   output "TestCase 58 sorting id PASSED" means TestCase number 58. TestCase is of sorting the field used is "id" and it has PASSED.

#Algorithm for testing
1. Filters
    a. List of values of fields like id,CORPORATEIDENTIFICATIONNUMBER etc are obtained.
    b. Top few values of fields are extracted.
    c. In an exhaustive test scenario we could check for all values.
    d. API is called for the extracted values.
    e. If all the values in the extracted list correspond to the filter. For e.g. if ID was 52 and all the ID values in the list are 52 then the testcase is passed.

2. Offset
    a. Without using offset API the XML file is downloaded.
    b. XML file is downloaded after using the offset API for e.g. 30.
    c. The file which is not offset the 31st element of that file is compared with the first element of file downloaded with offset.
    d. If they match testcase is passed.
    
3. Field Selection
    a. List of fields available is obtained.
    b. API is called for each of the fields.
    c. The returned file is checked to contain that it does not contain any other field.
    d. If it does not contain any other field apart from the field using which the API was called then the testcase is passed.
    e. The same is also carried out for multiple field selection by comma separated values.

4. Sorting
    a. API is called for sorting using each of the fields in the list.
    b. Using XPath the record values of the sorted field are extracted from the output sequentially.
    c. It is checked if the record values are actually sorted or not.
    d. Sorting for multiple fields is also done.
    
5. Joining
    a. Idea is to join different tables for e.g. table fo Maharashtra data with table of Bihar data, but the syntax for Join could not be obtained from the documentation.
    b. This testing is incomplete because the e.g. was not there in documentation.
    
6. Limit
    a. limit is used to specify the number of records which is to be extracted.
    b. The number of records is also specified in the count variable.
    c. By default the number of records is 100.
    d. This can be changed by limit=<value> parameter.
    e. Currently this parameter is not working.
    

