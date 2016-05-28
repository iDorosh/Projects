/**
 * Created by Ian Dorosh on 11/12/15.
 * MDF 3 1511
 * Week 3 Widget
 */

package com.idorosh.i_dorosh_widget;

import java.io.Serializable;

public class Info implements Serializable {
    //Variables to hold information that was added by the user
    private String mPhoneName;
    private String mPhoneOS;
    private String mPhoneCarrier;
    private String mPhonePrice;

    //Setting variables using the parameters
    public Info(String phoneName, String phoneOS, String phoneCarrier, String phonePrice){
        mPhoneName = phoneName;
        mPhoneOS = phoneOS;
        mPhoneCarrier = phoneCarrier;
        mPhonePrice = phonePrice;
    }

    //Returning variables
    public String getmPhoneName(){
        return mPhoneName;
    }

    public String getmPhoneOS(){
        return mPhoneOS;
    }

    public String getmPhoneCarrier(){return mPhoneCarrier;
    }

    public String getmPhonePrice(){return mPhonePrice;}
}
