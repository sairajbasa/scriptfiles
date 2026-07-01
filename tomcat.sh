# Install Java 21 (Amazon Corretto)
dnf install java-21-amazon-corretto -y

# Download and extract Tomcat 11.0.23
wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.23/bin/apache-tomcat-11.0.23.tar.gz
tar -zxvf apache-tomcat-11.0.23.tar.gz

# Add roles and user to tomcat-users.xml
sed -i '/<\/tomcat-users>/i \
<role rolename="manager-gui"/> \
<role rolename="manager-script"/> \
<user username="tomcat" password="root123456" roles="manager-gui,manager-script"/>' apache-tomcat-11.0.23/conf/tomcat-users.xml

# Remove restrictive Valve entries in context.xml to allow remote access
sed -i '21d' apache-tomcat-11.0.23/webapps/manager/META-INF/context.xml
sed -i '22d' apache-tomcat-11.0.23/webapps/manager/META-INF/context.xml

# Start Tomcat
sh apache-tomcat-11.0.23/bin/startup.sh
