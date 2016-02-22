#Read file
library(RCurl)
library("XML")

download.file("https://data.gov.in/api/datastore/resource.xml?resource_id=d1ac29db-549d-44b2-9bea-28d6e449ff85&api-key=f6718bc0c4cd26dcb82e0c11c48513a8",destfile="resource_file.xml",method="curl")

xmlfile <- xmlTreeParse("resource_file.xml")
xmltop = xmlRoot(xmlfile)

base_url<-"https://data.gov.in/api/datastore/resource.xml?resource_id=d1ac29db-549d-44b2-9bea-28d6e449ff85&api-key=f6718bc0c4cd26dcb82e0c11c48513a8"

### Extracting the values of few nodes id,CORPORATEIDENTIFICATIONNUMBER etc to be used in testing
#ID
base_doc <- xmlParse("resource_file.xml") 
abc<-xpathSApply(base_doc,"//id",xmlValue)
ID_list <-head(abc[-1],20)

#CORPORATEIDENTIFICATIONNUMBER
abc<-xpathSApply(base_doc,"//CORPORATEIDENTIFICATIONNUMBER",xmlValue)
CORPORATEIDENTIFICATIONNUMBER_list <-head(abc[-1],20)

#DATEOFREGISTRATION
abc<-xpathSApply(base_doc,"//DATEOFREGISTRATION",xmlValue)
DATEOFREGISTRATION_list <-head(abc[-1],20)

#AUTHORIZEDCAPITAL
abc<-xpathSApply(base_doc,"//AUTHORIZEDCAPITAL",xmlValue)
AUTHORIZEDCAPITAL_list <-head(abc[-1],20)

### Initializiation
tcid=1
output<-"TestCase#              Description#            Result#"
write(output,file="text_file.txt")

### Filters Test Cases of filters.
TC_count=0

#Looping through the id list and setting filter on ID
for(id in ID_list)
{   TC_count=TC_count+1
    filter<-paste0("filters\\[id\\]=",id)
    api_url<-paste0(base_url,'&',filter)
    download.file(api_url,destfile="resource_file_id.xml",method="curl")
    doc <- xmlParse("resource_file_id.xml") 
    test_id_list<-xpathSApply(doc,"//id",xmlValue)[-1]
    if(all(test_id_list==id))
    {
        output<-paste("TestCase",tcid," filters id",TC_count,"PASSED")
        write(output,file="text_file.txt",append=TRUE)
        tcid=tcid+1
    } else
    {  
        output<-paste("TestCase",tcid," filters id",TC_count,"FAILED")
        write(output,file="text_file.txt",append=TRUE)
        tcid=tcid+1
    }
}

#Looping through the CORPORATEIDENTIFICATIONNUMBER list and setting filter on CORPORATEIDENTIFICATIONNUMBER

TC_count=0
for(cid_number in CORPORATEIDENTIFICATIONNUMBER_list)
{   TC_count=TC_count+1
    filter<-paste0("filters\\[CORPORATEIDENTIFICATIONNUMBER\\]=",cid_number)
    api_url<-paste0(base_url,'&',filter)
    download.file(api_url,destfile="resource_file_CORPORATEIDENTIFICATIONNUMBER.xml",method="curl")
    doc <- xmlParse("resource_file_CORPORATEIDENTIFICATIONNUMBER.xml") 
    test_cid_number_list<-xpathSApply(doc,"//CORPORATEIDENTIFICATIONNUMBER",xmlValue)[-1]
    if(all(test_cid_number_list==cid_number))
    {
       output<-paste("TestCase",tcid," filters CORPORATEIDENTIFICATIONNUMBER",TC_count,"PASSED")
       write(output,file="text_file.txt",append=TRUE)
       tcid=tcid+1
    } else
    {  
        output<-paste("TestCase",tcid," filters CORPORATEIDENTIFICATIONNUMBER",TC_count,"FAILED")
        write(output,file="text_file.txt",append=TRUE)
        tcid=tcid+1
    }
}



### Offset TestCases Checking if offset API is working

# Setting the offset to 30 and getting the xml file with and without offset
offset<-"offset=30"
api_url<-paste0(base_url,'&',offset)
download.file(api_url,destfile="resource_file_offset.xml",method="curl")
download.file(base_url,destfile="resource_file.xml",method="curl")
doc_base <- xmlParse("resource_file.xml") 
abc<-xpathSApply(doc_base,"//id",xmlValue)
offset_list<-head(abc[-1],80)
doc <- xmlParse("resource_file_offset.xml") 
abc<-xpathSApply(doc,"//id",xmlValue)
offset_list_to_test<-head(abc[-1],80)

#Comparing the offset file to be tested with the 31st record in the original file
if(offset_list[31]==offset_list_to_test[1])
{
    output<-"TestCase Offset PASSED"
    write(output,file="text_file.txt",append=TRUE)
    tcid=tcid+1
} else
{
    output<-"TestCase Offset FAILED"
    write(output,file="text_file.txt",append=TRUE)
    tcid=tcid+1
}


### Field Selection TestCases

#Getting the list of fields available
fields_list<-xpathSApply(base_doc,"//fields/*",xmlName)

field<-"fields=id"

#Checking for each field in the fields list
for(field_name in fields_list)
{
    api_url<-paste0(base_url,'&',"fields=",field_name)
    download.file(api_url,destfile="resource_file_field.xml",method="curl")
    doc <- xmlParse("resource_file_field.xml")
    
    nodes_list<-xpathSApply(doc,"//records/*",xmlName)
    #Check that only the selected field is there in the output
    fields_to_check<-fields_list[fields_list!=field_name]
    case_passed=TRUE
    #None of the fields that were not selected should be there in the output
    for(field_to_check in fields_to_check)
    { if(any(nodes_list==field_to_check))
        {
            case_passed=FALSE
        }
    }   
    if(case_passed)
    {
        output<-paste("TestCase",tcid," fields",field_name,"PASSED")
        write(output,file="text_file.txt",append=TRUE)
        tcid=tcid+1
    } else
    {  
        output<-paste("TestCase",tcid," fields",field_name,"FAILED")
        write(output,file="text_file.txt",append=TRUE)
        tcid=tcid+1
    }
    
}

##Check for multiple fields in this case id,timestamp,COMPANYNAME

field<-"fields=id,timestamp,COMPANYNAME"
api_url<-paste0(base_url,'&',field)
download.file(api_url,destfile="resource_file_field.xml",method="curl")
doc <- xmlParse("resource_file_field.xml") 
nodes_list<-xpathSApply(doc,"//records/*",xmlName)

fields_to_check<-fields_list[fields_list!="id"]
fields_to_check<-fields_to_check[fields_to_check!="timestamp"]
fields_to_check<-fields_to_check[fields_to_check!="COMPANYNAME"]

case_passed=TRUE
for(field_to_check in fields_to_check)
{ if(any(nodes_list==field_to_check))
{
    case_passed=FALSE
}
}   
if(case_passed)
{
    output<-paste("TestCase",tcid," fields multiple fields id,timestamp,COMPANYNAME PASSED")
    write(output,file="text_file.txt",append=TRUE)
    tcid=tcid+1
} else
{  
    output<-paste("TestCase",tcid," fields multiple fields id,timestamp,COMPANYNAME FAILED")
    write(output,file="text_file.txt",append=TRUE)
    tcid=tcid+1
}


#Sorting TestCases
sort<-"sort\\[id\\]=asc"

#Sorting on the basis of fields_list
fields_list<-head(fields_list,10)

#Calling the sort api for each field in the fields_list
for(field_name in fields_list)
{
    api_url<-paste0(base_url,'&',"sort\\[",field_name,"\\]=asc")
    download.file(api_url,destfile="resource_file_sort.xml",method="curl")
    doc <- xmlParse("resource_file_sort.xml")
    
    #Extracting the values of records from the output of sorting
    xpath_to_check<- paste0("//",field_name)
    record_values<-xpathSApply(doc,xpath_to_check,xmlValue)[-1]
    if(field_name=="id")
    {
        record_values<-as.numeric(record_values)
    }
    if(!is.unsorted(record_values))
    {
        output<-paste("TestCase",tcid," sorting",field_name,"PASSED")
        write(output,file="text_file.txt",append=TRUE)
        tcid=tcid+1
    } else
    {  
        output<-paste("TestCase",tcid," sorting",field_name,"FAILED")
        write(output,file="text_file.txt",append=TRUE)
        tcid=tcid+1
    } 
        
}

#Sorting for two fields in this case AUTHORIZEDCAPITAL and COMPANYNAME
sort<-"sort\\[AUTHORIZEDCAPITAL\\]=asc&sort\\[COMPANYNAME\\]=asc"
api_url<-paste0(base_url,'&',sort)
download.file(api_url,destfile="resource_file_sort.xml",method="curl")
doc <- xmlParse("resource_file_sort.xml")
record_values<-xpathSApply(doc,"//AUTHORIZEDCAPITAL",xmlValue)[-1]

if(!is.unsorted(record_values))
{
    output<-paste("TestCase",tcid," sorting multiple fields AUTHORIZEDCAPITAL,COMPANYNAME PASSED")
    write(output,file="text_file.txt",append=TRUE)
    tcid=tcid+1
} else
{  
    output<-paste("TestCase",tcid," sorting multiple fields AUTHORIZEDCAPITAL,COMPANYNAME FAILED")
    write(output,file="text_file.txt",append=TRUE)
    tcid=tcid+1
}


#Joining
#Joining Maharashtra resource with Bihar resource
join_url<-"https://data.gov.in/api/datastore/resource.xml?resource_id\\[x\\]=d1ac29db-549d-44b2-9bea-28d6e449ff85&resource_id\\[y\\]=3f328009-8f64-426d-9228-750a3fe8e326&api-key=f6718bc0c4cd26dcb82e0c11c48513a8"
join<-"join\\[x\\]=id&join\\[y\\]=id"
api_url<-paste0()

#Limit

limit<-"limit=2000"
api_url<-paste0(base_url,'&',limit)

#Calling the API after setting the limit
download.file(api_url,destfile="resource_file.xml",method="curl")
doc <- xmlParse("resource_file.xml") 

abc<-xpathSApply(doc,"//id",xmlValue)

#Checking if the value returned is equal to the limit specified
if(length(abc)-1==2000)
{ output<-paste("TestCase",tcid," Limit PASSED")
  write(output,file="text_file.txt",append=TRUE)
  tcid=tcid+1
} else
{ output<-paste("TestCase",tcid," Limit FAILED")
  write(output,file="text_file.txt",append=TRUE)
  tcid=tcid+1
}
    

