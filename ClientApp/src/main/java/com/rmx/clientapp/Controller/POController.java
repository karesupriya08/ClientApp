package com.rmx.clientapp.Controller;

import com.rmx.clientapp.Model.Order;
import com.rmx.clientapp.POEntry;
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
public class POController {

    @Autowired
    POEntry po;

    @RequestMapping(value = "/POApprovedModule", method = RequestMethod.GET)
    public String showPOEntry(Model model) {
        return "POApprovedModule";
    }
     
    @RequestMapping(value = "getPOdata", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject getPOdata(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "style_no") String style_no, @RequestParam(value = "buyer_code") String buyer_code, Model model) {
      
       return  po.getPOdata(seas_code, style_no, buyer_code);
    }
    @RequestMapping(value = "getpoorderdata", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject getpoorderdata(@RequestParam(value = "seas_code") String seas_code,@RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour,  Model model) {
      
       return  po.getpoorderdata(seas_code, serial, colour);
    }
    @RequestMapping(value = "saveApproveddata", method = RequestMethod.POST, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject saveApproveddata(@RequestBody JSONObject formdata,  Model model) {
      
       return  po.saveApproveddata(formdata);
    }
}
