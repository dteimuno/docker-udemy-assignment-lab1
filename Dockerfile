FROM alpine:latest
RUN apk add openssh-server  vim  gcompat;exit 0
WORKDIR /app-files
#Set env variable of ADMIN_USER.
# In future, the value will be retreived from Vault.

#Add Value of ENV Variable to a file.
RUN export ADMIN_USER="appadmin"\
        && echo $ADMIN_USER > ./user-creds.txt \
#Unset the ENV Variable after value added to file.
        && unset ADMIN_USER
#Copy The App contents stored in custom-app folder to app-files.
#The txt files in custom-app can be ignored/skipped.
COPY custom-app /app-files
EXPOSE 8080
# Start app binary  named custom.
CMD ["/app-files/custom"]
