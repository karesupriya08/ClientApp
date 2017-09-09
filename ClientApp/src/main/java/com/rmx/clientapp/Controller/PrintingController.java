/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Controller;

import com.rmx.clientapp.Model.Order;
import com.rmx.clientapp.PrintingDao;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class PrintingController {
    @Autowired
    PrintingDao print;
    
     @RequestMapping(value = "/OGRSPrinting", method = RequestMethod.GET)
    public String showOGRSPrinting(Model model) {
        Order ord = new Order();
        model.addAttribute("command", ord);

        return "OGRSPrinting";
    }
    
     @RequestMapping(value = "/printOGRS", method = RequestMethod.GET)
    public @ResponseBody JSONObject printOGRS(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour_code") int colour_code, Model model) {
        JSONObject js = new JSONObject();
        
        return print.getPrintData(seas_code,serial,colour_code);
        //return new ModelAndView("redirect:/viewemp", "list", print.getPrintData(seas_code,serial,colour_code));
         // return new ModelAndView("modalTest");
    }
    /*    @RequestMapping(value = "/modalTest", method = RequestMethod.GET)
    public String showmodalTest(Model model) {
    Order ord = new Order();
    model.addAttribute("command", ord);
    
    return "modalTest";
    }*/
}
