package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;


public class WriteAndRead implements Serializable {

    private static final long serialVersionUID = 87368478L;


    //Creating a new file to save groups information
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
    public ArrayList<GroupsInfo> readFile(FileInputStream fin) throws IOException {
        ArrayList<GroupsInfo> arrayList = new ArrayList<>();
        try {

            ObjectInputStream oin = new ObjectInputStream(fin);
            arrayList = (ArrayList<GroupsInfo>) oin.readObject();
            oin.close();

        } catch(Exception e) {
            e.printStackTrace();
        }
        return arrayList;
    }

}
