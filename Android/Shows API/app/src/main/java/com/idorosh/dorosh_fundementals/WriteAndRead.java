package com.idorosh.dorosh_fundementals;

import android.app.Activity;
import android.content.Context;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by iDorosh on 10/7/15.
 */
public class WriteAndRead implements Serializable{


    private static final long serialVersionUID = 87368478L;

    //Creating a new file to save api data
    public void createFile(FileOutputStream fos, ArrayList info) throws IOException {


        try {
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(info);
            System.out.println("Success");
            oos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }



    //Method to read data from created file
    public List<Info> readFile(FileInputStream fin) throws IOException {
        List<Info> arrayList = new ArrayList<>();
        try {

            ObjectInputStream oin = new ObjectInputStream(fin);
            arrayList = (List<Info>) oin.readObject();
            System.out.println(arrayList);
            oin.close();

        } catch(Exception e) {
            e.printStackTrace();
        }
        return arrayList;
    }

}
