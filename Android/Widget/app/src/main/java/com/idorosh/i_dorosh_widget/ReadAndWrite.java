/**
 * Created by Ian Dorosh on 11/12/15.
 * MDF 3 1511
 * Week 3 Widget
 */

package com.idorosh.i_dorosh_widget;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ReadAndWrite implements Serializable {



    private static final long serialVersionUID = 87368478L;


    //Creating a new file to save phone information
    public boolean createFile(FileOutputStream fos, ArrayList info) throws IOException {
        try {
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(info);
            oos.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }



    //Method to read data from created file
    public ArrayList<Info> readFile(FileInputStream fin) throws IOException {
        ArrayList<Info> arrayList = new ArrayList<>();
        try {

            ObjectInputStream oin = new ObjectInputStream(fin);
            arrayList = (ArrayList<Info>) oin.readObject();
            System.out.println(arrayList);
            oin.close();

        } catch(Exception e) {
            e.printStackTrace();
        }
        return arrayList;
    }



}