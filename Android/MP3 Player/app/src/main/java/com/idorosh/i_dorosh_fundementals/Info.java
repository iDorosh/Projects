/**
 * Created by Ian Dorosh on 10/26/15.
 * MDF 3 1511
 * Week 1 Fundamentals
 */

package com.idorosh.i_dorosh_fundementals;

import android.content.res.Resources;
import android.widget.ImageView;

//Custom class for song information
public class Info{
    //variables for the data that is being set by the service
    private String mTitle;
    private String mArtist;
    private String mUri;
    private int mCover;

    //Setting variables to data from the service
    public Info(String title, String uri, String artist, int cover){
        mTitle = title;
        mUri = uri;
        mArtist = artist;
        mCover = cover;
    }

    //Returning variables to services and main activity
    public String getmTitle(){return mTitle;}

    public String getmUri(){return mUri;}

    public String getmArtist(){return mArtist;}

    public int getmCover(){return mCover;}

}

