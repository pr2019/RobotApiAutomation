*** Settings ***
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections
Resource  Resources/Resource.robot
Documentation  This is API Automantion Suite Using Robot Framework
Test Setup  Welcome To Robot Automation Suite
Test Teardown  End TestCase
# Force Tags  Hello  # This apply on all TCs
# Default Tags  Hello  # This will apply one those TCs don't have any tags
# Test Timeout  90


*** Variables ***
${Base_URL}   https://thetestingworldapi.com/
${StudentID}  10279408
${Base_URL2}  https://reqres.in/
${first_name}  Pradeep
${last_name}   Sahani

*** Test Cases ***
TC_001_List_All_User_Request
#    [Setup]  Welcome To Robot Automation Suite
#    [Teardown]  End TestCase
    [Tags]   Smoke
    [Documentation]
    Fetch and Validate Get Status Code  ${Base_URL2}  api/users?page=2  200

TC_002_Fetch_Student_Details_By_Id
    [Documentation]
     Fetch and Validate Get Status Code  ${Base_URL2}   api/user/2   200

TC_003_Get_With_Param
    [Documentation]
    create session  Get_Param  ${Base_URL2}
    # To create dictionay use &
    &{param}=   create dictionary  page=1
    ${response}=  get request  Get_Param  /api/users param=${param}
    log to console  ${response.status_code}
    log to console  ${param}
    log to console  ${response.text}

    ${status_code}=  convert to string  ${response.status_code}
    should be equal  ${status_code}  200
    ${JsonResponse}=  to json  ${response.content}
    @{name_list}  get value from json   ${JsonResponse}   data[0].name
    log to console  ${name_list}
    ${name}=  get from list  ${name_list}  0
    log to console   ${name}
    should not be equal  ${name}   Eve

TC_004_Validate_Delete_Request
    [Documentation]
    Fetch and Validate Delete Request  ${Base_URL2}   api/user/2   204


TC_005_PostRequest:
    [Documentation]
    Create Session  postReq  ${Base_URL2}
    ${body}=  create dictionary   name=Pradeep   job=Automation Engineer
    ${Response}=  post request  postReq  /api/users   json=${body}
    #log to console  ${Response.content}

    should be equal as numbers  ${Response.status_code}  201

    log to console  ${Response.json()}

TC_006_PutReq:
    [Documentation]
    # Create session
    create session  putReq  ${Base_URL2}

    # create data to update
    ${body}=  create dictionary  name=Pradeep   job=Network Automation Engineer

    # Send Post request
    ${Response}=  put request  putReq  /api/users/2   json=${body}

    # Validate the status code
    should be equal as numbers  ${Response.status_code}   200

    # show the updated data
    log to console  ${Response.json()}

TC_007_CreateNew_Resource:
    [Documentation]
    # Create a new session
    create session  newReq  ${BASE_URL2}

    # Create a data dictionary to send in session request
    ${body}=  create dictionary  name=Shiva  job=Incident Manager

    # Send the post request
    ${Response}=  post request  newReq  /api/users  json=${body}

    #Validate the status code
    should be equal as numbers  ${Response.status_code}  201

    # print the newly created data
    log to console  ${Response.content}


TC_008_End_to_End_TestCase:
    [Documentation]
    &{body}=   create dictionary  first_name=${first_name}  middle_name=Kumar  last_name=${last_name}  date_of_birth=02/07/1995

    ${id}=  Post Create Data and Validate  ${Base_URL}   ${body}   200

    &{body1}=  create dictionary   id=${id}   first_name=Neel    middle_name=Kanth    last_name=vairagi   date_of_birth=02/07/1995

    Put Update and Validate  ${Base_URL}   ${id}  ${body1}   Neel

    Fetch and Validate Delete Request  ${Base_URL}   /api/studentsDetails/${id}  200

    ${get_deleted_request}=  Fetch and Validate Get Status Code  ${Base_URL}  /api/studentsDetails/${id}  200

    log to console  ${get_deleted_request.content}
    ${json_deleted_response}=  to json  ${get_deleted_request.content}
    @{delete_status_list}=  get value from json  ${json_deleted_response}   status
    ${delete_status}=  get from list  ${delete_status_list}  0
    should be equal as strings   ${delete_status}   false

TC_009_Post_Read_Content
    [Documentation]
    ${body}=  Fetch Requet Content
    ${id}=  Post Create Data and Validate  ${Base_URL}   ${body}   200
     Fetch and Validate Get Status Code  ${Base_URL}   /api/studentsDetails/${id}  200

*** Keywords ***