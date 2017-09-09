/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Controller;

import com.rmx.clientapp.FabDao;
import com.rmx.clientapp.Model.Order;
import java.util.List;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author Supriya Kare
 */
@Controller
public class FabRateEntryController {
    @Autowired
    FabDao fabdao;
    
     @RequestMapping(value="FabRateEntry",method=RequestMethod.GET)
    public String showCancelQuantity(Model model)
    {
        return "FabRateEntry";
    }
     @RequestMapping(value="getSerial",method=RequestMethod.GET)
      public @ResponseBody List getSerial(@RequestParam(value="seas_code") String seas_code,@RequestParam(value="buyer_code") String buyer_code, @RequestParam(value="style_no") String style_no)
      {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
          return fabdao.getSerial(seas_code,buyer_code,style_no);
      }
       @RequestMapping(value="getColour",method=RequestMethod.GET)
      public @ResponseBody List getColour(@RequestParam(value="seas_code") String seas_code,@RequestParam(value="buyer_code") String buyer_code, @RequestParam(value="style_no") String style_no,@RequestParam(value="serial") int serial)
      {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
          return fabdao.getColour(seas_code,buyer_code,style_no,serial);
      }
         @RequestMapping(value="getdata",method=RequestMethod.GET)
      public @ResponseBody JSONObject getdata(@RequestParam(value="seas_code") String seas_code,@RequestParam(value="serial") int serial,@RequestParam(value="colour") int colour)
      {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
          return fabdao.getdata(seas_code,serial,colour);
      }
        @RequestMapping(value="getOtherDetails",method=RequestMethod.GET)
      public @ResponseBody JSONObject getOtherDetails(@RequestParam(value="seas_code") String seas_code, @RequestParam(value="style_no") String style_no,@RequestParam(value="serial") int serial,@RequestParam(value="allcontrol") String allcontrol,@RequestParam(value="colour") int colour)
      {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
          return fabdao.getOtherDetails(seas_code,style_no,serial,allcontrol,colour);
      }
        @RequestMapping(value="getallcontrol",method=RequestMethod.GET)
      public @ResponseBody JSONObject getallcontrol(@RequestParam(value="seas_code") String seas_code,@RequestParam(value="buyer_code") String buyer_code, @RequestParam(value="style_no") String style_no)
      {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
          return fabdao.getallcontrol(seas_code,buyer_code,style_no);
      }
        @RequestMapping(value="getWorkType",method=RequestMethod.GET)
      public @ResponseBody List getWorkType()
      {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
          return fabdao.getWorkType();
      }
         @RequestMapping(value="updateFabRateEntry",method=RequestMethod.POST)
      public @ResponseBody JSONObject updateFabRateEntry(@RequestBody Order formdata)
      {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
          System.out.println("formdata-------------"+formdata.toString());
          return fabdao.updateFabRateEntry(formdata);
      }
      
}
