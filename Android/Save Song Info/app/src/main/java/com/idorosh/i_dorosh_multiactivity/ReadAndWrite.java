package com.idorosh.i_dorosh_multiactivity;

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
public class ReadAndWrite implements Serializable{



    private static final long serialVersionUID = 87368478L;


    //Creating a new file to save song information
    public boolean createFile(FileOutputStream fos, ArrayList info) throws IOException {


        try {
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(info);
            System.out.println("Success");
            oos.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
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
