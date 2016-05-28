package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import java.io.Serializable;
import java.util.ArrayList;

public class GroupsInfo implements Serializable {
    //Variables to hold information about groups
    private String mGName;
    private String mGInfo;
    ArrayList<SantaInfo> mSantas = new ArrayList<>();

    //Setting variables using the parameters
    public GroupsInfo(String name, String info, ArrayList santas){
        mGName = name;
        mGInfo = info;
        mSantas = santas;
    }

    //Returning variables
    public String getmGName(){return mGName;}

    public String getmGInfo(){
        return mGInfo;
    }

    public ArrayList getmSantas(){
        return mSantas;
    }
}
