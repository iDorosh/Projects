package com.idorosh.dorosh_fundementals;


import java.io.Serializable;

public class Info implements Serializable{
    //variables for the data from the api
    private String mTitle;
    private String mYear;
    private String mGenre;
    private String mPlot;

    //Setting variables to the data that's being passed in.
    public Info(String title, String year, String genre, String plot){
        mTitle = title;
        mYear = year;
        mGenre = genre;
        mPlot = plot;
    }

    //Returning variables to main activity
    public String getmTitle(){
        return mTitle;
    }

    public String getmYear(){
        return mYear;
    }

    public String getmGenre(){
        return mGenre;
    }

    public String getmPlot(){return mPlot;}
}
