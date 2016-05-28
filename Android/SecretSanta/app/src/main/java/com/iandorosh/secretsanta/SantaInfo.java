package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import java.io.Serializable;

public class SantaInfo implements Serializable {
    //Variables to hold information about the secret santas
    private String mSantaName;
    private String mContact;
    private String mInterests;
    private String mContactType;

    //Setting variables using the parameters
    public SantaInfo(String name, String contact, String interests, String contactTpe){
        mSantaName = name;
        mContact = contact;
        mInterests = interests;
        mContactType = contactTpe;
    }

    //Returning variables
    public String getmSantaName(){return mSantaName;
    }

    public String getmContact(){
        return mContact;
    }

    public String getmInterests(){return  mInterests;}


    public String getmContactType(){return  mContactType;}


}
