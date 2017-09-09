/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Controller;

import com.rmx.clientapp.CancelQtyDao;
import com.rmx.clientapp.Model.Cancelqty;
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

@Controller
public class CancelQtyController 
{
    @Autowired
    CancelQtyDao canqtydao;
    
    @RequestMapping(value="CancelQuantity",method=RequestMethod.GET)
    public String showCancelQuantity(Model model)
    {
        model.addAttribute("command",new Order());
        return "CancelQuantity";
    }
    
    @RequestMapping(value = "/getCancelDat", method = RequestMethod.GET, headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    List<JSONObject> showCancelData(@RequestParam(value = "serial") int serial,@RequestParam(value="seas_code")String seas_code, Model model) {
        List alldata = canqtydao.getCancelData(serial,seas_code);
        System.out.println("alldata=========="+alldata);
          String flag = "false";
        if(alldata.isEmpty())
        {
           // alldata.add(flag);
        }
        return alldata;
    }
    @RequestMapping(value="cancelQuantity",method=RequestMethod.POST,headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    JSONObject cancelQuantity(@RequestBody Cancelqty formdata)
    {
      JSONObject js= canqtydao.addCancelQty(formdata);
        //System.out.println("formdata========="+formdata);
      
        
        return js;
    }
    
}
