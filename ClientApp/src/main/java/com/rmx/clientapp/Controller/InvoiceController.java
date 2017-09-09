/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Controller;

import com.eclipsesource.json.Json;
import com.eclipsesource.json.JsonArray;
import com.eclipsesource.json.JsonValue;
import com.rmx.clientapp.InvoiceDao;
import com.rmx.clientapp.Model.Invoice;
import com.rmx.clientapp.Model.Order;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
public class InvoiceController {

    @Autowired
    InvoiceDao indao;

    @RequestMapping(value = "InvoiceCancel", method = RequestMethod.GET)
    public String showCancelQuantity(Model model) {
        model.addAttribute("command", new Order());
        return "InvoiceCancel";
    }

    @RequestMapping(value = "/checkSerial", method = RequestMethod.GET, headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    org.json.simple.JSONObject checkSerial(@RequestParam(value = "serial") int serial, @RequestParam(value = "seas_code") String seas_code, Model model) {
        JSONObject js = indao.checkSerial(serial, seas_code);
        return js;
    }

    @RequestMapping(value = "/getShipNo", method = RequestMethod.GET, headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    JSONObject getShipNo(@RequestParam(value = "serial") int serial, @RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "colour") int colour, Model model) {
        JSONObject js = indao.getShipNo(serial, seas_code, colour);
        return js;
    }

    @RequestMapping(value = "/checkShipStatus", method = RequestMethod.GET, headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    JSONObject checkShipStatus(@RequestParam(value = "serial") int serial, @RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "colour") int colour, @RequestParam(value = "ship_no") int ship_no, Model model) {
        JSONObject js = (JSONObject) indao.checkShipStatus(serial, seas_code, colour, ship_no);
        return js;
    }

    @RequestMapping(value = "/cancelInvoice", method = RequestMethod.POST, headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    JSONObject cancelInvoice(@RequestBody Invoice invoice) {
        JSONObject js = (JSONObject) indao.cancelInvoice(invoice);
        return js;
    }

    @RequestMapping(value = "InvoiceEntry", method = RequestMethod.GET)
    public String showInvoiceEntry(Model model) {
        model.addAttribute("command", new Order());
        return "InvoiceEntry";
    }

    @RequestMapping(value = "/getStyleNoOnSeason", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject showgetStyleNoOnSeason(@RequestParam(value = "seas_code") String seas_code) {

        return indao.getStyleNo(seas_code);
    }

    @RequestMapping(value = "/getBuyerCodeOnstyle", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject showgetBuyerCodeOnstyle(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "style_no") String style_no) {

        return indao.getBuyerCode(seas_code, style_no);
    }

    @RequestMapping(value = "/getOrderdataforInvoiceEntry", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject getOrderdataforInvoiceEntry(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "style_no") String style_no) {

        return indao.getOrderdata(seas_code, buyer_code, style_no);
    }

    @RequestMapping(value = "/getOrderdataforInvoiceEntryClick", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject getOrderdataforInvoiceEntryClick(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "style_no") String style_no, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour) {

        return indao.getOrderdataforInvoiceEntryClick(seas_code, buyer_code, style_no, serial, colour);
    }

    @RequestMapping(value = "/getShippingUnit", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    List getShippingUnit(@RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "comp_code") int comp_code) {

        return indao.getShippingUnit(buyer_code, comp_code);
    }

    @RequestMapping(value = "/getWorkUnit", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    List getWorkUnit() {

        return indao.getWorkUnit();
    }

    @RequestMapping(value = "/saveInvoiceenrty", method = RequestMethod.POST, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject saveInvoiceenrty(@RequestBody JSONObject jsonObj) {
        return indao.saveInvoiceenrty(jsonObj);
    }

    @RequestMapping(value = "/InsertIntotempInvoice", method = RequestMethod.POST, produces = {"application/xml", "application/json"})
    public @ResponseBody
    void InsertIntotempInvoice(@RequestBody JSONObject tempinvoice) {
        // System.out.println("tempinvoice----------"+tempinvoice.toJSONString());
        int res = indao.InsertIntotempInvoice(tempinvoice);

    }

    @RequestMapping(value = "/Inserttempship", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    void Inserttempship(@RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour, @RequestParam(value = "price") float price,@RequestParam(value = "toship") int toship) {
        System.out.println("toship--------"+toship);
             
        //System.out.println("" + serial + colour + price);
        if(toship!=0){
         indao.Inserttempship(serial , colour , price);
        }
    }
    @RequestMapping(value = "/Trunctempship", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody  void Trunctempship() {
         indao.Trunctempship();
    }


}
