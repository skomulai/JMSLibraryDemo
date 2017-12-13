* Settings *
Library    Collections
Library    JMSLibrary
Library    OperatingSystem
Suite Setup     Init Provider  ${INITIAL_CONTEXT_FACTORY}  ${JNDI_PROVIDER_URL}  connect=true  start=true
Suite Teardown  Close Connection

* Variables *
${INITIAL_CONTEXT_FACTORY}  org.apache.activemq.artemis.jndi.ActiveMQInitialContextFactory
${JNDI_PROVIDER_URL}        tcp://localhost:61616
${QUEUE_TEXT}               QUEUE_TEXT.JMSLIBRARY.TEST
${QUEUE_BYTES}              QUEUE_BYTES.JMSLIBRARY.TEST
${QUEUE_BYTES_WITH_PROPS}   QUEUE_BYTES_WITH_PROPERTIES.JMSLIBRARY.TEST
${TOPIC}                    TOPIC.JMSLIBRARY.TEST
${TEXT}                     Hello world!\nSecond row
${PROPERTYKEY}              secret_message_number
${PROPERTYVALUE}            161

* Test Cases *
Send and Receive BytesMessage With Topic
    [Documentation]    Test sending and receiving messages using a JMS topic
    ...                Requires initialization and closing of a topic consumer 
    [Tags]    both
    [Setup]  Init Topic Consumer  ${TOPIC}
    # Read content from a file
    ${text_from_file} =    Get File    data/jms_msg_content
    Send To Topic As Bytes Message    ${TOPIC}    ${text_from_file}
    ${text_msg_from_queue} =    Receive As Bytes Message
    Should Be Equal  ${text_msg_from_queue}  ${text_from_file}
    [Teardown]  Close Consumer

Send TextMessage To Queue
    [Documentation]    Test sending a text message to a JMS queue
    [Tags]    send
    [Setup]  Clear Queue Once  ${QUEUE_TEXT}
    Send To Queue As Text Message    ${QUEUE_TEXT}    ${TEXT}

Receive TextMessage From Queue
    [Documentation]    Test receiving a text message from a JMS queue
    [Tags]    receive
    Check Queue Depth    ${QUEUE_TEXT}    1
    ${text_msg_from_queue} =    Receive Once From Queue As Text Message    ${QUEUE_TEXT}        
    Should Be Equal  ${text_msg_from_queue}  ${TEXT}

Send BytesMessage To Queue
    [Documentation]    Test sending a bytes message to a JMS queue
    [Tags]    send
    [Setup]  Clear Queue Once  ${QUEUE_BYTES}
    # Read content from a file
    ${text_from_file} =    Get File    data/jms_msg_content
    Send To Queue As Bytes Message    ${QUEUE_BYTES}    ${text_from_file}

Receive BytesMessage From Queue
    [Tags]    receive
    Check Queue Depth    ${QUEUE_BYTES}    1
    ${text_msg_from_queue} =    Receive Once From Queue As Bytes Message    ${QUEUE_BYTES}
    # Read the original content from a file for comparison purposes
    ${text_from_file} =    Get File    data/jms_msg_content
    Should Be Equal  ${text_msg_from_queue}  ${text_from_file}

Send BytesMessage To Queue With Properties
    [Tags]    send
    [Setup]  Clear Queue Once  ${QUEUE_BYTES_WITH_PROPS}
    # Read content from a file
    ${text_from_file} =    Get File    data/jms_msg_content
    # Custom string properties as a dictionary (map)
    &{message_properties} = 	Create Dictionary    ${PROPERTYKEY}=${PROPERTYVALUE}
    Send To Queue As Bytes Message With Properties    ${QUEUE_BYTES_WITH_PROPS}    ${text_from_file}    ${message_properties}	

Receive BytesMessage From Queue With Properties
    [Tags]    receive
    Check Queue Depth    ${QUEUE_BYTES_WITH_PROPS}    1
    ${text_msg_from_queue} =    Receive Once From Queue As Bytes Message    ${QUEUE_BYTES_WITH_PROPS}
    # Read the original content from a file for comparison purposes
    ${text_from_file} =    Get File    data/jms_msg_content
    ${property} =	Get String Property    ${PROPERTYKEY}
	Should Be Equal As Numbers	${property}    ${PROPERTYVALUE}
    Should Be Equal  ${text_msg_from_queue}  ${text_from_file}
    
*** Keywords ***  
Send To Queue As Text Message
    [Arguments]    ${queue_name}    ${text_content}
    Create Text Message  ${text_content}
    Send To Queue    ${queue_name}
    
Send To Queue As Bytes Message
    [Arguments]    ${queue_name}    ${text_content}    ${encoding}=UTF-8
    Create Bytes Message  ${text_content}    ${encoding}
    Send To Queue  ${queue_name}

Send To Queue As Bytes Message With Properties
    [Arguments]    ${queue_name}    ${text_content}    ${propertymap}    ${encoding}=UTF-8
    Create Bytes Message  ${text_content}    ${encoding}
    # Add all the custom string properties to the message
    @{keys} =    Get Dictionary Keys    ${propertymap}
    : FOR    ${current_key}    IN    @{keys}
    \    ${value} =    Get From Dictionary    ${propertymap}    ${current_key}
    \    Set String Property    ${current_key}	${value}    
    Send To Queue    ${queue_name}
    
Send To Topic As Bytes Message
    [Arguments]    ${topic_name}    ${text_content}    ${encoding}=UTF-8
    Create Bytes Message  ${text_content}    ${encoding}
    Send To Topic  ${topic_name}

Receive Once From Queue As Text Message
    [Arguments]    ${queue_name}
    Receive Once From Queue  ${queue_name}
    ${body} =  Get Text
    [Return]    ${body}

Receive Once From Queue As Bytes Message
    [Arguments]    ${queue_name}    ${encoding}=UTF-8
    Receive Once From Queue  ${queue_name}
    ${body}=  Get Bytes As String  ${encoding}
    [Return]    ${body}
    
Receive As Bytes Message
    [Arguments]    ${encoding}=UTF-8
    Receive
    ${body}=  Get Bytes As String  ${encoding}    
    [Return]    ${body}
    
Check Queue Depth
    [Arguments]    ${queue_name}    ${expected_msg_count}
    ${msg_count} =    Queue Depth    ${queue_name}
    Should Be Equal As Numbers    ${expected_msg_count}    ${msg_count}