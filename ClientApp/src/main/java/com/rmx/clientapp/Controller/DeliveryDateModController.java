/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Controller;

import com.rmx.clientapp.OrderDao;
import com.rmx.clientapp.Model.Order;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class DeliveryDateModController {

    @Autowired
    OrderDao dao;

    @RequestMapping(value = "/DeliveryDateEntry", method = RequestMethod.GET)
    public String deliverydate(Model model) {
        // model.addAttribute("command", new Season());
        model.addAttribute("command", new Order());
        return "DeliveryDateEntry";
        //return new ModelAndView("empform", "command", new Emp());
    }

    @ModelAttribute("seasonListCode")
    public List<String> getcountryList() {
        List seasonList;
        seasonList = dao.getAllSeasonsCode();
        return seasonList;
    }

  
    @RequestMapping(value = "/getseasondesc", method = RequestMethod.GET, produces = {"text/xml"})
    public @ResponseBody
    String showseasdesc(@RequestParam(value = "seas_code") String seas_code, Model model) {
        // System.out.println("seas_code" + seas_code);
        String seas_desc = dao.getSeasonsDesc(seas_code);
        return seas_desc;
    }

    @RequestMapping(value = "/getalldata", method = RequestMethod.GET, headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    List<String> showalldata(@RequestParam(value = "serial") int serial, Model model) {
        List alldata = dao.getalldata(serial);
        // System.out.println("alldata=========="+alldata.toString());
        return alldata;
    }

    @RequestMapping(value = "/getalldata1", method = RequestMethod.GET, headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    List<Order> showalldata1(@RequestParam(value = "serial") int serial,@RequestParam(value="seas_code")String seas_code, Model model) {
        List alldata = dao.getalldata1(serial,seas_code);
        System.out.println("alldata=========="+seas_code);
        return alldata;
    }

    @RequestMapping(value = "/modDelivery_date", method = RequestMethod.GET, produces = {"text/xml"})
    public @ResponseBody
    String modDelivery_date(@RequestParam("serial") int serial, @RequestParam("delv_date") Date delv_date,@RequestParam("seas_code") String seas_code,Model model) {
        //java.util.Date newdate=null;
        String newdate = null;
        System.out.println("In modDelivery_datemodDelivery_date=============");
        try {
            SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
            newdate = dt.format(delv_date);
            //  newdate=(java.util.Date) dt.parse(newdate1);
            System.out.println("newdate==============" + newdate);
        } catch (Exception e) {
            e.printStackTrace();
        }
        int result = dao.updateDelivery_date(serial, newdate,seas_code);
        System.out.println("result==========" + result);
        if (result == 0) {
            return "Delivery Date has not been updated";
        }

        return "Delivery Date has been updated";

    }
}
