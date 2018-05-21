/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package json;

import java.awt.Image;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.stream.Collectors;
import javax.imageio.ImageIO;
import javax.servlet.ServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author IE
 */
public abstract class MyRequest{

    /**
     * Neste caso, a requesição vem diretamente de um form html
     * @param req
     * @return
     * @throws JSONException 
     */
    public static JSONObject inRequest(ServletRequest req) throws JSONException {
        JSONObject jsonObj = new JSONObject();
        Map<String, String[]> params = req.getParameterMap();
        for (Map.Entry<String, String[]> entry : params.entrySet()) {
            String v[] = entry.getValue();
            Object o = (v.length == 1) ? v[0] : v;
            jsonObj.put(entry.getKey(), o);
        }
        return jsonObj;
    }
    /**
     * Neste caso, o json vem no corpo da requisição em decorrência 
     * de uma função JavaScript, e não diretamente do 
     * submit em um form html
     * @param request 
     * @return JSONObject
     * @throws JSONException
     * @throws IOException 
     */
    public static JSONObject inBody(ServletRequest request) throws JSONException, IOException {
       return new JSONObject(request.getReader().lines().collect(Collectors.joining()));
    
    }
    
    public static Image inBody(InputStream inputRequest) throws JSONException, IOException {
       return ImageIO.read(inputRequest);    
    }
}
