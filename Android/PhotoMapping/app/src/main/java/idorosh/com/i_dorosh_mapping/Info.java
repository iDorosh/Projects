/**
 * Created by Ian Dorosh on 11/18/15.
 * MDF 3 1511
 * Week 4 Mapping
 */

package idorosh.com.i_dorosh_mapping;

import java.io.Serializable;

public class Info implements Serializable {
    //Variables to hold information about the Images
    private String mTitle;
    private String mCaption;
    private double mLon;
    private double mLat;
    private String mUri;

    //Setting variables using the parameters
    public Info(String title, String caption, double lon, double lat, String uri){
        mTitle = title;
        mCaption = caption;
        mLon = lon;
        mLat = lat;
        mUri = uri;
    }

    //Returning variables
    public String getmTitle(){return mTitle;
    }

    public String getmCaption(){
        return mCaption;
    }

    public double getmLon(){
        return mLon;
    }

    public double getmLat(){return mLat;}

    public String getmUri(){return  mUri;}
}
