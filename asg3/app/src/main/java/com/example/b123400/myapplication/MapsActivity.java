package com.example.b123400.myapplication;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.speech.tts.TextToSpeech;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.net.URL;
import java.util.Locale;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback, GoogleMap.OnMarkerClickListener {

    private GoogleMap mMap;
    private Marker marker;
    TextToSpeech textToSpeech;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);


        textToSpeech = new TextToSpeech(getApplicationContext(), new TextToSpeech.OnInitListener() {
            @Override
            public void onInit(int status) {
                textToSpeech.setLanguage(Locale.US);
            }
        });
    }


    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;

        // Add a marker in Sydney and move the camera
        LatLng shit = new LatLng(22.400301, 114.203105);
        mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(shit, 20));
        mMap.setOnMarkerClickListener(this);
        
        reloadMarker();
    }

    public void reloadMarker() {
        if (marker != null) {
            marker.remove();
        }

        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                Bitmap bmp = null;
                try {

                    URL url = new URL("http://tdcctv.data.one.gov.hk/ST703F.JPG");
                    bmp = BitmapFactory.decodeStream(url.openConnection().getInputStream());

                } catch (Exception e) {
                    e.printStackTrace();
                }
                final Bitmap finalShit = bmp;
                if (bmp != null) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {

                            LatLng shit = new LatLng(22.400301, 114.203105);

                            marker = mMap.addMarker(new MarkerOptions()
                                    .position(shit)
                                    .icon(BitmapDescriptorFactory.fromBitmap(finalShit)));

                        }
                    });
                }
            }
        });
        thread.start();
    }

    public boolean onMarkerClick (Marker marker) {
        reloadMarker();

        textToSpeech.speak("Tai Po Road near MTR Racecourse Station", TextToSpeech.QUEUE_FLUSH, null);

        return true;
    }
}
