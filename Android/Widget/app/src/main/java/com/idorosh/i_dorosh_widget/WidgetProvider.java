/**
 * Created by Ian Dorosh on 11/12/15.
 * MDF 3 1511
 * Week 3 Widget
 */

package com.idorosh.i_dorosh_widget;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;

public class WidgetProvider extends AppWidgetProvider{


    public static final String ACTION_VIEW_DETAILS = "com.idorosh.i_dorosh_widget.ACTION_VIEW_DETAILS";
    public static final String EXTRA_ITEM = "com.idorosh.i_dorosh_widget.WidgetProvider.EXTRA_ITEM";

    //is used to verify that the add button has been clicked.
    private static final String addClick = "addClicked";


    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager,
                         int[] appWidgetIds) {

        for(int i = 0; i < appWidgetIds.length; i++) {

            int widgetId = appWidgetIds[i];

            Intent intent = new Intent(context, WidgetService.class);
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId);

            RemoteViews widgetView = new RemoteViews(context.getPackageName(), R.layout.widget_layout);
            widgetView.setRemoteAdapter(R.id.phone_list, intent);
            widgetView.setEmptyView(R.id.phone_list, R.id.empty);

            //Setting an onclick pending intent for the add button so the add button can open the add activity
            widgetView.setOnClickPendingIntent(R.id.addButton,
                    addPendingIntent(context, addClick));

            Intent detailIntent = new Intent(ACTION_VIEW_DETAILS);
            PendingIntent pIntent = PendingIntent.getBroadcast(context, 0, detailIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetView.setPendingIntentTemplate(R.id.phone_list, pIntent);

            appWidgetManager.updateAppWidget(widgetId, widgetView);
        }

        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }


    protected PendingIntent addPendingIntent(Context context, String action) {
        //setting action to intent and returning a pending intent
        Intent intent = new Intent(context, getClass());
        intent.setAction(action);
        return PendingIntent.getBroadcast(context, 0, intent, 0);
    }


    @Override
    public void onReceive(Context context, Intent intent) {


        //Will open the details class and put extra of the phoneinfo which is the current phone from the row
        //Will also put extra of provider so the add class can distinguish what is opening it
        if(intent.getAction().equals(ACTION_VIEW_DETAILS)) {
            Info phoneInfo = (Info)intent.getSerializableExtra(EXTRA_ITEM);
            if(phoneInfo != null) {
                Intent detailsIntent = new Intent(context, Details.class);
                detailsIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                detailsIntent.putExtra("info", phoneInfo);
                detailsIntent.putExtra("caller", "provider" );
                context.startActivity(detailsIntent);
            }
        }
        //Will open the add activity and passes in the adding string extra so the add activity can distinguish what is opening it
        if (addClick.equals(intent.getAction())){
            Intent addIntent = new Intent(context, Add.class);
            addIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            addIntent.putExtra("add", "adding");
            context.startActivity(addIntent);
        }

        super.onReceive(context, intent);
    }



}
