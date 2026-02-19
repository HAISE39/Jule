package com.vellixao.modmenu;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.IBinder;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;

/**
 * FloatingMenuService - Mod Menu Melayang (Overlay)
 * Bisa di-compile di AIDE Pro.
 */
public class FloatingMenuService extends Service {

    private WindowManager windowManager;
    private LinearLayout menuLayout;
    private WindowManager.LayoutParams params;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);

        // Setup Layout Mod Menu
        menuLayout = new LinearLayout(this);
        menuLayout.setOrientation(LinearLayout.VERTICAL);
        menuLayout.setBackgroundColor(Color.argb(200, 0, 0, 0));
        menuLayout.setPadding(20, 20, 20, 20);

        TextView title = new TextView(this);
        title.setText("VELLIXAO MOD MENU (JAVA)");
        title.setTextColor(Color.WHITE);
        title.setGravity(Gravity.CENTER);
        menuLayout.addView(title);

        final EditText inputSearch = new EditText(this);
        inputSearch.setHint("Cari Nilai...");
        inputSearch.setHintTextColor(Color.GRAY);
        inputSearch.setTextColor(Color.YELLOW);
        menuLayout.addView(inputSearch);

        final EditText inputEdit = new EditText(this);
        inputEdit.setHint("Ubah Jadi...");
        inputEdit.setHintTextColor(Color.GRAY);
        inputEdit.setTextColor(Color.GREEN);
        menuLayout.addView(inputEdit);

        Button btnSearchEdit = new Button(this);
        btnSearchEdit.setText("SEARCH & EDIT (DWORD)");
        btnSearchEdit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    int sVal = Integer.parseInt(inputSearch.getText().toString());
                    int eVal = Integer.parseInt(inputEdit.getText().toString());

                    List<Long> addresses = MemoryScanner.searchDword(sVal);
                    if (addresses.isEmpty()) {
                        Toast.makeText(getApplicationContext(), "Nilai tidak ditemukan di Java Heap", Toast.LENGTH_SHORT).show();
                    } else {
                        int count = 0;
                        for (long addr : addresses) {
                            if (MemoryScanner.writeDword(addr, eVal)) {
                                count++;
                            }
                        }
                        Toast.makeText(getApplicationContext(), "Berhasil ubah " + count + " nilai", Toast.LENGTH_SHORT).show();
                    }
                } catch (Exception e) {
                    Toast.makeText(getApplicationContext(), "Input Error!", Toast.LENGTH_SHORT).show();
                }
            }
        });
        menuLayout.addView(btnSearchEdit);

        Button btnClose = new Button(this);
        btnClose.setText("CLOSE MENU");
        btnClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                stopSelf();
            }
        });
        menuLayout.addView(btnClose);

        // Setup Window Parameters
        int layoutFlag;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            layoutFlag = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
        } else {
            layoutFlag = WindowManager.LayoutParams.TYPE_PHONE;
        }

        params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                layoutFlag,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
        );

        params.gravity = Gravity.TOP | Gravity.LEFT;
        params.x = 0;
        params.y = 100;

        // Bikin menu bisa ditarik (draggable)
        menuLayout.setOnTouchListener(new View.OnTouchListener() {
            private int initialX;
            private int initialY;
            private float initialTouchX;
            private float initialTouchY;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        initialX = params.x;
                        initialY = params.y;
                        initialTouchX = event.getRawX();
                        initialTouchY = event.getRawY();
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        params.x = initialX + (int) (event.getRawX() - initialTouchX);
                        params.y = initialY + (int) (event.getRawY() - initialTouchY);
                        windowManager.updateViewLayout(menuLayout, params);
                        return true;
                }
                return false;
            }
        });

        windowManager.addView(menuLayout, params);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (menuLayout != null) windowManager.removeView(menuLayout);
    }
}
