/**
 * Created by Ian Dorosh on 11/12/15.
 * MDF 3 1511
 * Week 3 Widget
 */

package com.idorosh.i_dorosh_widget;

import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.util.ArrayList;

public class WidgetViewFactory implements RemoteViewsService.RemoteViewsFactory {

    private static final int ID_CONSTANT = 0x0101010;

    //Array list to hold information from the file
    ArrayList<Info> itemsInfo = new ArrayList<>();
    private Context mContext;

    public WidgetViewFactory(Context context) {
        mContext = context;

    }

    @Override
    public void onCreate() {}

    @Override
    public int getCount() {
        return itemsInfo.size();
    }

    @Override
    public long getItemId(int position) {
        return ID_CONSTANT + position;
    }

    @Override
    public RemoteViews getLoadingView() {
        return null;
    }

    @Override
    public RemoteViews getViewAt(int position) {

        //Will hold the information for the phone in itemsinfo for the specific position
        Info currentPhone = itemsInfo.get(position);

        RemoteViews itemView = new RemoteViews(mContext.getPackageName(), R.layout.row_layout);

        //setting the text labels to the phones information
        itemView.setTextViewText(R.id.phoneName, currentPhone.getmPhoneName());
        itemView.setTextViewText(R.id.phoneOS, currentPhone.getmPhoneOS());
        itemView.setTextViewText(R.id.phonePrice, currentPhone.getmPhonePrice());

        //will open the details activity when the row is selected
        Intent intent = new Intent();
        intent.putExtra(WidgetProvider.EXTRA_ITEM, currentPhone);
        itemView.setOnClickFillInIntent(R.id.phone, intent);

        return itemView;
    }

    @Override
    public int getViewTypeCount() {
        return 1;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

    @Override
    public void onDataSetChanged() {
        //Will read data from file and set itemsInfo to that information
        try {
            FileInputStream fis = mContext.openFileInput("phone.data");
            itemsInfo = readFile(fis);
        }
        catch (Exception ex) {
        }

    }

    @Override
    public void onDestroy() {
        itemsInfo.clear();
    }

    //Method to read data from created file
    public ArrayList<Info> readFile(FileInputStream fin) throws IOException {
        ArrayList<Info> arrayList = new ArrayList<>();
        try {

            ObjectInputStream oin = new ObjectInputStream(fin);
            arrayList = (ArrayList<Info>) oin.readObject();
            oin.close();

        } catch(Exception e) {
            e.printStackTrace();
        }
        return arrayList;
    }

}
