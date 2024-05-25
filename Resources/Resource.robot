*** Settings ***
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections

*** Variables ***
${Base_URL}   https://thetestingworldapi.com/
${Base_URL2}  https://reqres.in/

*** Keywords ***
Fetch and Validate Get Status Code
    [Arguments]  ${url}   ${relativePath}   ${expectedStatusCode}
    create session  SName  ${url}
    ${Response}=  get request  SName  ${relativePath}
    #log to console  ${Response.status_code}
    log to console  ${Response.text}
    ${actual_code}=  convert to string  ${Response.status_code}
    should be equal  ${actual_code}  ${expectedStatusCode}
    [Return]  ${Response}

Fetch Details and Validate
    [Arguments]  ${url}   ${Id}  ${expectedValue}

    create session  SName  ${url}
    ${get_request}=  GET On Session   SName   /api/studentsDetails/${Id}
    # log to console  ${get_request.content}
    ${json_response}=  to json  ${get_request.content}
    @{L_f_name}=  get value from json  ${json_response}  data.first_name
    ${first_name}=  get from list  ${L_f_name}  0

    @{l_name_list}=  get value from json  ${json_response}   data.last_name
    ${last_name}=  get from list  ${l_name_list}  0

    should be equal   ${first_name}  ${expectedValue}

Fetch and Validate Delete Request
    [Arguments]  ${url}   ${relativePath}  ${expectedValue}

    Create Session    SName    ${url}
    ${Response}=      Delete Request    SName    ${relativePath}
    log to console  ${Response.status_code}
    Should Be Equal As Numbers    ${Response.status_code}    ${expectedValue}

Post Create Data and Validate
    [Arguments]  ${url}   ${body}  ${expectedValue}

    create session  SName  ${url}
    &{headers}=   create dictionary  Content-Type=application/json
    ${post_response}=  post request  SName   api/studentsDetails   headers=${headers}   json=${body}
    #log to console  ${post_response.content}

    ${json_response}=  to json  ${post_response.content}
    @{id_list}=  get value from json  ${json_response}  id
    ${id}=  get from list  ${id_list}  0

    [Return]  ${id}



Put Update and Validate
    [Arguments]  ${url}   ${id}  ${body}  ${expectedValue}

    create session  SName  ${url}
    &{headers}=  create dictionary  Content-Type=application/json

    ${put_response}=  put request   SName   api/studentsDetails/${id}  headers=${headers}   data=${body}
    #log to console  ${post_response.content}

#    ${json_put_response}=  to json  ${put_response.content}
#    @{status_list}=  get value from json  ${json_put_response}   status
#    ${status}=  get from list  ${status_list}  0

    should be equal as numbers  ${put_response.status_code}  200
#    should be equal as strings   ${status}   true
#
#    Fetch Details and Validate  ${Base_URL}  ${id}  ${expectedValue}



