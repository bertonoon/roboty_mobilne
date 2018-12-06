package pkg3d;

import com.sun.j3d.utils.applet.MainFrame;
import com.sun.j3d.utils.behaviors.vp.OrbitBehavior;
import com.sun.j3d.utils.geometry.ColorCube;
import com.sun.j3d.utils.geometry.Primitive;
import com.sun.j3d.utils.geometry.Sphere;
import com.sun.j3d.utils.geometry.Box;
import com.sun.j3d.utils.image.TextureLoader;
import javax.media.j3d.*;
import javax.swing.*;
import java.awt.*;
import com.sun.j3d.utils.universe.SimpleUniverse;
import java.applet.Applet;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.media.j3d.Transform3D;
import javax.vecmath.Color3f;
import javax.vecmath.Color4f;
import javax.vecmath.Point2f;
import javax.vecmath.Point3d;
import javax.vecmath.Point3f;
import javax.vecmath.Vector3f;



public class Program3D extends Applet implements ActionListener{
    Timer t;
    TransformGroup kostka1;
    TransformGroup kostka1_X;
    TransformGroup kostka1_Z;
    Transform3D axis1Z;
    Transform3D axis1X;
    
    TransformGroup kostka2;
    TransformGroup kostka2_X;
    TransformGroup kostka2_Z;
    Transform3D axis2Z;
    Transform3D axis2X;
    
    TransformGroup kostka3;
    TransformGroup kostka3_X;
    TransformGroup kostka3_Z;
    Transform3D axis3Z;
    Transform3D axis3X;
    
    float mnoznik = 1.0f;
    float rotZ = 0;
    BufferedReader br;
    
    JButton start;
    JLabel czaslab;
    float czas =0f;
    float dt = 0.00408f;
    
    public Program3D(){
    setLayout(new BorderLayout());
     Canvas3D c = new Canvas3D(SimpleUniverse.getPreferredConfiguration()); 
    SimpleUniverse universe = new SimpleUniverse(c);
    BranchGroup group = new BranchGroup();
   
    OrbitBehavior ob = new OrbitBehavior(c, OrbitBehavior.REVERSE_ROTATE);
    ob.setSchedulingBounds(new BoundingSphere());
    universe.getViewingPlatform().setViewPlatformBehavior(ob);
    
    add("Center", c);
         
    JPanel panel = new JPanel();
    add("South", panel);
    
    start = new JButton("Start");
    start.addActionListener((ae) -> {
      
        start.setEnabled(false);
        czas = 0f;
         new Thread(new Runnable(){
         @Override
         public void run() {
             File file = new File("exptable.txt");
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                   czas += dt;
                   czaslab.setText("Czas: " + Integer.toString((int)(czas)) + " s");
                    String sep[] = line.split(" ");
                    
                    
                    float Z = Float.parseFloat(sep[0]) * (float)Math.PI/180;
                    axis1Z.rotZ(Z);
                    kostka1_Z.setTransform(axis1Z);
                    float X = Float.parseFloat(sep[1]) * (float)Math.PI/180;
                    axis1X.rotX(X);
                    kostka1_X.setTransform(axis1X);
                    
                    
                    Z = Float.parseFloat(sep[2]) * (float)Math.PI/180;
                    axis2Z.rotZ(Z);
                    kostka2_Z.setTransform(axis2Z);
                    X = Float.parseFloat(sep[3]) * (float)Math.PI/180;
                    axis2X.rotX(X);
                    kostka2_X.setTransform(axis2X);
                    
                    
                    Z = Float.parseFloat(sep[4]) * (float)Math.PI/180;
                    axis3Z.rotZ(Z);
                    kostka3_Z.setTransform(axis3Z);
                    X = Float.parseFloat(sep[5]) * (float)Math.PI/180;
                    axis3X.rotX(X);
                    kostka3_X.setTransform(axis3X);
                    
                    
                    
                    try {
                        Thread.sleep(4);
                    } catch (InterruptedException ex) {
                        Logger.getLogger(Program3D.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (FileNotFoundException ex) {
                Logger.getLogger(Program3D.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(Program3D.class.getName()).log(Level.SEVERE, null, ex);
            }
            start.setEnabled(true);
         }
         
            
        }).start();
    });
    
    JButton reset = new JButton("Reset kamery");
    reset.addActionListener((ae) -> {
        universe.getViewingPlatform().setNominalViewingTransform();
    });
    panel.add(reset);
    panel.add(start);
    czaslab = new JLabel("Czas: 0 s");
    panel.add(czaslab);
    TransformGroup trans = new TransformGroup();
    trans.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE); 

    kostka1 = new TransformGroup();
    kostka1_Z = new TransformGroup();
    kostka1_Z.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE); 
    kostka1_X = new TransformGroup();
    kostka1_X.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE); 


    kostka2 = new TransformGroup();
    kostka2_Z = new TransformGroup();
    kostka2_Z.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE); 
    kostka2_X = new TransformGroup();
    kostka2_X.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE); 

    kostka3 = new TransformGroup();
    kostka3_Z = new TransformGroup();
    kostka3_Z.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE); 
    kostka3_X = new TransformGroup();
    kostka3_X.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE); 
     
    axis1Z = new Transform3D();
    axis1X = new Transform3D();
    axis2Z = new Transform3D();
    axis2X = new Transform3D();
    axis3Z = new Transform3D();
    axis3X = new Transform3D();
   
     Color3f black = new Color3f(0.0f, 0.0f, 0.0f);
     Color3f white = new Color3f(1,1,1);
     Color3f red = new Color3f(0.7f,.15f,.15f);
     Color3f green = new Color3f(0,1,0);
     Color3f blue = new Color3f(0,0,1);
     
       Appearance ap = new Appearance();
        ap.setMaterial(new Material(red, black, red, black, 1.0f));
        int primflags = Primitive.GENERATE_NORMALS + Primitive.GENERATE_TEXTURE_COORDS;
        Box box = new Box(0.1f*mnoznik, 0.1f*mnoznik, 0.1f*mnoznik, ap);
        
        kostka1_Z.addChild(box);
        kostka1_X.addChild(kostka1_Z);
        kostka1_Z.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);
        kostka1_X.setTransform(axis1Z);
        kostka1.addChild(kostka1_X);
        Transform3D offset = new Transform3D();
        offset.setTranslation(new Vector3f(-0.4f*mnoznik,0f, 0f));
        kostka1.setTransform(offset);
        group.addChild(kostka1);
        
        
      
    
   
    
    
        Box box2 = new Box(0.1f*mnoznik, 0.1f*mnoznik, 0.1f*mnoznik, ap);
        kostka2_Z.addChild(box2);
        kostka2_X.addChild(kostka2_Z);
        kostka2_Z.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);
        kostka2_X.setTransform(axis2Z);
        kostka2.addChild(kostka2_X);
      
        offset.setTranslation(new Vector3f(0.4f*mnoznik,0f, 0f));
        kostka2.setTransform(offset);
        group.addChild(kostka2);
        
        Box box3 = new Box(0.1f*mnoznik, 0.1f*mnoznik, 0.1f*mnoznik, ap);
        kostka3_Z.addChild(box3);
        kostka3_X.addChild(kostka3_Z);
        kostka3_Z.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);
        kostka3_X.setTransform(axis3Z);
        kostka3.addChild(kostka3_X);
      
        group.addChild(kostka3);
        
        /*
        Transform3D sciana_t = new Transform3D();
        Appearance wyglad = new Appearance();
        Material material = new Material();
        material.setSpecularColor(new Color3f(Color.WHITE));
        material.setDiffuseColor(new Color3f(Color.WHITE));
        wyglad.setMaterial(material);
        Shape3D sufit = tworzPowierzchnie(new Vector3f(-2.0f,-0.8f,0.3f), new Vector3f(2f,0.8f,0.3f));
        sufit.setAppearance(wyglad);
        TransformGroup sufit_g = new TransformGroup();
        sciana_t.rotX(Math.PI/2);
        sufit_g.setTransform(sciana_t);
        sufit_g.addChild(sufit);
        
        group.addChild(sufit_g);
        */
        
        LineArray lineX = new LineArray(2, LineArray.COORDINATES);
         Appearance appearanceWhite = new Appearance();
        ColoringAttributes coloringAttributesW = new ColoringAttributes();
        coloringAttributesW.setColor(new Color3f(Color.white));
        appearanceWhite.setColoringAttributes(coloringAttributesW);
        
        float siatka = 0.05f*mnoznik;
        for (int i = -18; i < 23; i++){
            if (i != 0 && i != 8 && i != -8   )
            {
                lineX = new LineArray(2, LineArray.COORDINATES);
                lineX.setCoordinate(0, new Point3f(i*siatka -0.1f, -0.1f*mnoznik, -0.1f*mnoznik));
                lineX.setCoordinate(1, new Point3f(i*siatka-0.1f, -0.1f*mnoznik, 1.6f*mnoznik));
                group.addChild(new Shape3D(lineX, appearanceWhite));
            }
        }
        for (int i = 0; i < 35; i++){
            if (i != 0     )
            {
                lineX = new LineArray(2, LineArray.COORDINATES);
                lineX.setCoordinate(0, new Point3f( -1f*mnoznik, -0.1f*mnoznik, i*siatka-0.1f));
                lineX.setCoordinate(1, new Point3f(1f*mnoznik, -0.1f*mnoznik, i*siatka-0.1f));
                group.addChild(new Shape3D(lineX, appearanceWhite));
            }
        }
        
        for (int i = -18; i < 23; i++){
            if (i != 0  && i != 8 && i != -8   )
            {
                lineX = new LineArray(2, LineArray.COORDINATES);
                lineX.setCoordinate(0, new Point3f(i*siatka -0.1f, -0.1f*mnoznik, -0.1f*mnoznik));
                lineX.setCoordinate(1, new Point3f(i*siatka-0.1f, 1.6f*mnoznik, -0.1f*mnoznik));
                group.addChild(new Shape3D(lineX, appearanceWhite));
            }
        }
        
          for (int i = 0; i < 35; i++){
            if (i != 0   )
            {
                lineX = new LineArray(2, LineArray.COORDINATES);
                lineX.setCoordinate(0, new Point3f( -1f*mnoznik, i*siatka-0.1f, -0.1f*mnoznik));
                lineX.setCoordinate(1, new Point3f(1f*mnoznik, i*siatka-0.1f, -0.1f*mnoznik));
                group.addChild(new Shape3D(lineX, appearanceWhite));
            }
        }
        
        Appearance appearanceGreen = new Appearance();
        ColoringAttributes coloringAttributesG = new ColoringAttributes();
        coloringAttributesG.setColor(new Color3f(Color.green));
        appearanceGreen.setColoringAttributes(coloringAttributesG);
        lineX = new LineArray(2, LineArray.COORDINATES);
        lineX.setCoordinate(0, new Point3f(-1000.0f*mnoznik, -0.1f*mnoznik, -0.1f*mnoznik));
        lineX.setCoordinate(1, new Point3f(1000.0f*mnoznik, -0.1f*mnoznik, -0.1f*mnoznik));
        group.addChild(new Shape3D(lineX, appearanceGreen));
        
        Appearance appearanceRed = new Appearance();
        ColoringAttributes coloringAttributesR = new ColoringAttributes();
        coloringAttributesR.setColor(new Color3f(Color.red));
        appearanceRed.setColoringAttributes(coloringAttributesR);
        lineX = new LineArray(2, LineArray.COORDINATES);
        lineX.setCoordinate(0, new Point3f(-0.1f*mnoznik, -0.1f*mnoznik, -0.1f*mnoznik));
        lineX.setCoordinate(1, new Point3f(-0.1f*mnoznik, 1000.0f*mnoznik, -0.1f*mnoznik));
        group.addChild(new Shape3D(lineX, appearanceRed));
        lineX = new LineArray(2, LineArray.COORDINATES);
        lineX.setCoordinate(0, new Point3f(0.4f-0.1f*mnoznik, -0.1f*mnoznik, -0.1f*mnoznik));
        lineX.setCoordinate(1, new Point3f(0.4f-0.1f*mnoznik, 1000.0f*mnoznik, -0.1f*mnoznik));
        group.addChild(new Shape3D(lineX, appearanceRed));
        lineX = new LineArray(2, LineArray.COORDINATES);
        lineX.setCoordinate(0, new Point3f(-0.4f*mnoznik-0.1f*mnoznik, -0.1f*mnoznik, -0.1f*mnoznik));
        lineX.setCoordinate(1, new Point3f(-0.4f*mnoznik-0.1f*mnoznik, 1000.0f*mnoznik, -0.1f*mnoznik));
        group.addChild(new Shape3D(lineX, appearanceRed));

        Appearance appearanceBlue = new Appearance();
        ColoringAttributes coloringAttributesB = new ColoringAttributes();
        coloringAttributesB.setColor(new Color3f(Color.blue));
        appearanceBlue.setColoringAttributes(coloringAttributesB);
        lineX = new LineArray(2, LineArray.COORDINATES);
        lineX.setCoordinate(0, new Point3f(-0.1f*mnoznik, -0.1f*mnoznik, -0.1f*mnoznik));
        lineX.setCoordinate(1, new Point3f(-0.1f*mnoznik, -0.1f*mnoznik, 1000.0f*mnoznik));
        group.addChild(new Shape3D(lineX, appearanceBlue));
        lineX = new LineArray(2, LineArray.COORDINATES);
        lineX.setCoordinate(0, new Point3f(-0.1f*mnoznik-0.4f*mnoznik, -0.1f*mnoznik, -0.1f*mnoznik));
        lineX.setCoordinate(1, new Point3f(-0.1f*mnoznik-0.4f*mnoznik, -0.1f*mnoznik, 1000.0f*mnoznik));
        group.addChild(new Shape3D(lineX, appearanceBlue));
        lineX = new LineArray(2, LineArray.COORDINATES);
        lineX.setCoordinate(0, new Point3f(-0.1f*mnoznik+0.4f*mnoznik, -0.1f*mnoznik, -0.1f*mnoznik));
        lineX.setCoordinate(1, new Point3f(-0.1f*mnoznik+0.4f*mnoznik, -0.1f*mnoznik, 1000.0f*mnoznik));
        group.addChild(new Shape3D(lineX, appearanceBlue));

       
        
        
        Appearance a = new Appearance();
        a.setColoringAttributes(coloringAttributesW);
        Font3D f3d = new Font3D(new Font("TestFont", Font.PLAIN, 1),new FontExtrusion());
        Text3D text3D = new Text3D(f3d, new String("Filtr Komplementarny"), new Point3f(0f, 0.0f, 0.0f));
        text3D.setCapability(Geometry.ALLOW_INTERSECT);
        Shape3D s3D1 = new Shape3D(text3D, a);
        TransformGroup text1 = new TransformGroup();
        text1.addChild(s3D1);
        Transform3D text1t = new Transform3D();
        text1t.setScale(0.02);
        text1t.setTranslation(new Vector3f(-0.095f, 0.0f, 0.10f));
        text1.setTransform(text1t);
        kostka1_Z.addChild(text1);
    
    
        text3D = new Text3D(f3d, new String("Filtr Mahony'ego"), new Point3f(0f, 0.0f, 0.0f));
        text3D.setCapability(Geometry.ALLOW_INTERSECT);
        s3D1 = new Shape3D(text3D, a);
        TransformGroup text2 = new TransformGroup();
        text2.addChild(s3D1);
        Transform3D text2t = new Transform3D();
        text2t.setScale(0.02);
        text2t.setTranslation(new Vector3f(-0.08f, 0.0f, 0.10f));
        text2.setTransform(text2t);
        kostka2_Z.addChild(text2);

        text3D = new Text3D(f3d, new String("Filtr Kalmana"), new Point3f(0f, 0.0f, 0.0f));
        text3D.setCapability(Geometry.ALLOW_INTERSECT);
        s3D1 = new Shape3D(text3D, a);
        TransformGroup text3 = new TransformGroup();
        text3.addChild(s3D1);
        Transform3D text3t = new Transform3D();
        text3t.setScale(0.02);
        text3t.setTranslation(new Vector3f(-0.06f, 0.0f, 0.10f));
        text3.setTransform(text3t);
        kostka3_Z.addChild(text3);
        
        Color3f light1Color = new Color3f(1,0,0);
        
        BoundingSphere bounds = new BoundingSphere(new Point3d(0,0,0),10000);
        Vector3f light1Direction = new Vector3f(4,-7,-12);
        DirectionalLight light1 = new DirectionalLight(light1Color, light1Direction);
        light1.setInfluencingBounds(bounds);
        group.addChild(light1);
        
        AmbientLight ambientLight = new AmbientLight(new Color3f(0.5f,.5f,.5f));
        ambientLight.setInfluencingBounds(bounds);
        group.addChild(ambientLight);
        
        universe.getViewingPlatform().setNominalViewingTransform();
        universe.addBranchGraph(group);
    
        t = new Timer(1000,this);
        t.start();
        
       
        
            
        
    }

 @Override
    public void actionPerformed(ActionEvent ae) {
        /*Vector3f pos=new Vector3f();
        Vector3f posref=new Vector3f();
        wszystko.getLocalToVworld(pozycja);
        pozycja.get(posref);
            punkt.getLocalToVworld(pozycja);
            pozycja.get(pos);
          System.out.println((pos.x - posref.x) + " " + (pos.y-posref.y) + " " +( pos.z-posref.z));
          kostka.getLocalToVworld(pozycja);
          pozycja.get(pos);
           System.out.println((pos.x - posref.x) + " " + (pos.y-posref.y) + " " +( pos.z-posref.z) + "\n");
*/
     
        
       
    
        if (ae.getSource() ==t){
            //rotZ += 45 * Math.PI/180;
            //axisZ.rotZ(rotZ);
            //trans2.setTransform(axisZ);
            
        }
        
        
    }
    

    private static Shape3D tworzPowierzchnie(Vector3f frompos, Vector3f topos){
    
        Point3f[]  coords = new Point3f[4];
        for(int i = 0; i< 4; i++)
            coords[i] = new Point3f();

        Point2f[]  tex_coords = new Point2f[4];
        for(int i = 0; i< 4; i++)
            tex_coords[i] = new Point2f();

        coords[0].y = frompos.y;
        coords[1].y = frompos.y;
        coords[2].y = topos.y;
        coords[3].y = topos.y;

        coords[0].x = topos.x;
        coords[1].x = frompos.x;
        coords[2].x = frompos.x;
        coords[3].x = topos.x;

        coords[0].z = frompos.z;
        coords[1].z = frompos.z;
        coords[2].z = topos.z;
        coords[3].z = topos.z;

        tex_coords[0].x = 0.0f;
        tex_coords[0].y = 0.0f;
        
        tex_coords[1].x = 5.0f;
        tex_coords[1].y = 0.0f;

        tex_coords[3].x = 0.0f;
        tex_coords[3].y = 5.0f;

        tex_coords[2].x = 5.0f;
        tex_coords[2].y = 5.0f;


        QuadArray powierzchniaarray = new QuadArray(4, GeometryArray.COORDINATES|
                GeometryArray.TEXTURE_COORDINATE_2);
        powierzchniaarray.setCoordinates(0,coords);

        powierzchniaarray.setTextureCoordinates(0, tex_coords);
        Shape3D powierzchnia = new Shape3D(powierzchniaarray);
    return powierzchnia;
    }
    
     public static void main(String args[]){
         MainFrame xx = new MainFrame(new Program3D(), 1000,600);
         

   }

}
