package com.iandorosh.secretsanta;

import java.io.Serializable;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512



public class SendInfo implements Serializable {
        //Variables to hold information about the Paired santas that will be sent with messages
        private String mRecipient;
        private String mRecipientContactInfo;
        private String mType;
        private String mString;

        //Setting variables using the parameters
        public SendInfo(String recipient, String recipientContactInfo, String string, String type){
            mRecipient = recipient;
            mRecipientContactInfo = recipientContactInfo;
            mString = string;
            mType = type;
        }

        //Returning variables
        public String getmRecipient(){return mRecipient;
        }

        public String getmRecipientContactInfo(){
            return mRecipientContactInfo;
        }

        public String getmString(){return  mString;}

        public String getmType(){return  mType;}
    }

