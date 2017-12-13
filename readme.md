This project demonstrates how to use JMSLibrary (for Robot Framework) to test JMS applications/environments

* Code: https://github.com/ilkkatoje/robotframework-jmslibrary
* Documentation : http://ilkkatoje.github.io/robotframework-jmslibrary/


*Requires java, curl, and sudo-less docker in path*

Usage
-----

Initialize environment (download required stuff, start artemis-mq docker container): 
* _prepare_demo_environment.sh_

After running the above mentioned command you can use ActiveMQ Artemis Web UI. 

URL is http://localhost:8161/console/

Username/password = _admin/admin_


Run test: 
* _run_tests.sh_


Cleanup environment (stop artemis-mq docker container):
* _cleanup_demo_environment.sh_

To remove artemis-mq docker image completely, run 

_docker rmi vromero/activemq-artemis:2.3.0_
