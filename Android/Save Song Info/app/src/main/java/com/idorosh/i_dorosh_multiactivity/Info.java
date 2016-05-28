package com.idorosh.i_dorosh_multiactivity;

import java.io.Serializable;

//Class that holds the songs information
public class Info implements Serializable{
    //variables for the data that the user creates
    private String mTitle;
    private String mAlbum;
    private String mArtist;


    //Setting variables to the data that's being passed in.
    public Info(String title, String album, String artist){
        mTitle = title;
        mAlbum = album;
        mArtist = artist;

    }

    //Returning variables to main activity
    public String getmTitle(){
        return mTitle;
    }

    public String getmAlbum(){
        return mAlbum;
    }

    public String getmArtist(){return mArtist;}
}