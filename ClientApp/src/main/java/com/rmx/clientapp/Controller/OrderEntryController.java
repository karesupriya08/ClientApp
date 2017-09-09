package com.rmx.clientapp.Controller;

import com.rmx.clientapp.Model.Buyer;
import com.rmx.clientapp.OrderDao;
import com.rmx.clientapp.Model.Season;
import com.rmx.clientapp.Model.Order;
import com.rmx.clientapp.POEntry;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class OrderEntryController {

    @Autowired
    OrderDao dao;
    @Autowired
    POEntry po;

    public void setDao(OrderDao dao) {
        this.dao = dao;
    }

    @RequestMapping(value = "/NormalOrderEntry", method = RequestMethod.GET)
    public String showNormalOrderEntry(Model model) {
        Order ord = new Order();
        model.addAttribute("command", ord);
        populateSeasonList(model);
        return "NormalOrderEntry";
    }

    @RequestMapping(value = "/Demo", method = RequestMethod.GET)
    public String showTryCopy(Model model) {
        // referenceData();
        Order ord = new Order();
        //Season s=new Season();
        model.addAttribute("command", ord);
        // model.addAttribute("season",emp.getSeasonbean().getSeas_desc());
        // System.out.println("season"+emp.getSeasonbean().getSeas_desc());
        //populateSeasonList(model);
        return "Demo";
        //return new ModelAndView("empform", "command", new Emp());
    }

    @RequestMapping(value = "/trycopy", method = RequestMethod.GET)
    public String showTryCopy1(Model model) {

        Order ord = new Order();

        model.addAttribute("command", ord);

        return "trycopy";

    }

    @RequestMapping(value = "/getseasondescMaxserial", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject showSeasdescMaxSerial(@RequestParam(value = "seas_code") String seas_code, Model model) {
        // System.out.println("seas_code" + seas_code);
        String seas_desc = dao.getSeasonsDesc(seas_code);
        int maxSerial = dao.getMaxSerial(seas_code);
        Order ord = new Order();
        JSONObject js = new JSONObject();
        js.put("seas_desc", seas_desc);
        js.put("maxSerial", maxSerial);
        return js;
    }

    @RequestMapping(value = "/getBuyerCodeList", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    List showBuyerCodeList(Model model) {
        List b = dao.getBuyerCode();
        JSONObject js = new JSONObject();
        js.put("buyer_code", b);
        return b;
    }

    @RequestMapping(value = "/getStyleNo", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    List showStyleNo(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "buyer_code") String buyer_code, Model model) {
        List style = dao.getStyleNo(seas_code, buyer_code);
        JSONObject js = new JSONObject();
        js.put("style_no", style);
        return style;
    }

    @RequestMapping(value = "getOrderdata", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject showOrderdata(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "style_no") String style_no, @RequestParam(value = "buyer_code") String buyer_code, Model model) {
        JSONObject order = dao.getOrderdata1(seas_code, style_no, buyer_code);
        int ord_stat = dao.getMaxOrd_stat(seas_code, style_no, buyer_code);
        order.put("ord_stat", ord_stat);
        order.put("colourlist", dao.getColourList());
        return order;
    }

    @RequestMapping(value = "getOrderno", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject showOrderno(@RequestParam(value = "order_no") String orderno, @RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "style_no") String style_no) {
        JSONObject order_no = dao.getOrderno(orderno, seas_code, style_no);
        return order_no;
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public ModelAndView save(@ModelAttribute("emp") Order ord) {
        dao.save(ord);
        return new ModelAndView("redirect:/viewemp");//will redirect to viewemp request mapping
    }

    @RequestMapping(value = "/AddOrder", method = RequestMethod.POST)
    public @ResponseBody
    JSONObject addOrder(@RequestBody Order formdata) {
        //System.out.println("oreer========" + formdata.getSeas_code());
        System.out.println("formdata=======" + formdata);
        JSONObject js=new JSONObject();
        //System.out.println("colour code=======" + formdata.getChoices().toString());
        int res = dao.save(formdata);
        if(res>=1)
        {
            js.put("msg", "Order Added");
        }
        else
        {
            js.put("msg", "Order not Added");
        }
        System.out.println("Record added===========" + res);
        return js;
    }

    @RequestMapping(value = "/AddOrder1", method = RequestMethod.POST)
    public @ResponseBody
    Order getMock(@RequestBody Order formdata) {
        System.out.println("season=========" + formdata);
        System.out.println("season=========" + formdata.getSeas_code());
        System.out.println("season=========" + formdata.getB_style());

        return formdata;
    }
    /*protected ModelAndView onSubmit(Object command) throws Exception {
     Emp emp = (Emp) command;
     dao.save(emp);
     return new ModelAndView("viewemp","emp",emp);
     }
     */

    @RequestMapping("/viewemp")
    public ModelAndView viewemp() {
        List<Order> list = dao.getEmployees();
        // System.out.println("List========" + list);
        return new ModelAndView("viewemp", "list", list);
    }

    @SuppressWarnings("unchecked")
    public void populateSeasonList(Model model) {
        List seasonList = dao.getAllSeasonsCode();
        model.addAttribute(seasonList);
        //System.out.println("seasonList========"+seasonList);

    }

    @RequestMapping(value = "/getSeasList", method = RequestMethod.GET)
    public @ResponseBody
    List<Season> populateSeasList(Model model) {
        // List seasonList = dao.getAllSeasonsCode();
        List seasonList = dao.getSeasonsCode();

        model.addAttribute(seasonList);
        return seasonList;
        //System.out.println("seasonList========"+seasonList);

    }

    @ModelAttribute("countryList")
    public List<String> getcountryList() {
        List<String> countryList = new ArrayList<String>();
        countryList.add("India");
        countryList.add("US");
        countryList.add("UK");
        return countryList;
    }

    @RequestMapping("/states")
    public @ResponseBody
    @ModelAttribute("stateList")
    ModelAndView hello(@RequestParam(value = "country") String country, Model model) {
        Order ord = new Order();
        List<String> stateList = new ArrayList<String>();
        stateList.add("delhi");
        stateList.add("up");
        System.out.println(stateList);
        model.addAttribute(stateList);
        String str = "{\"city\": \"" + country + "\"}}";
        ModelAndView mv = new ModelAndView("/empform", "ord", ord);
        model.addAttribute(stateList);

        return mv;

    }

    @RequestMapping(value = "/getstates", method = RequestMethod.GET, headers = {"Accept=text/xml, application/json"})
    public @ResponseBody
    List<String> showstates() {
        List<String> stateMap = new ArrayList<String>();
        stateMap.add("maharashtra");
        stateMap.add("delhi");
        stateMap.add("Bihar");
        return stateMap;
    }

    @RequestMapping(value = "/getstates1", method = RequestMethod.GET)
    public @ResponseBody
    String showstatesList() {
        List<String> stateMap = new ArrayList<String>();
        //put your logic to add state on basis of country
        stateMap.add("maharashtra");
        stateMap.add("delhi");
        stateMap.add("Bihar");
        System.out.println("stateMap" + stateMap);
        System.out.println("json");
        return "aaaaaaaa";
    }

    @RequestMapping(value = "/springcontent", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    Order getcontent() {
        Order ord = new Order();
        ord.setB_style("aaa");
        //  ord.setSeason("bbb");
        return ord;
    }

    @RequestMapping(value = "/OrderModification", method = RequestMethod.GET)
    public String showOrderModification(Model model) {
        Order ord = new Order();
        model.addAttribute("command", ord);
        populateSeasonList(model);
        return "OrderModification";
    }

    @RequestMapping(value = "/getseasondesc", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject showSeasdesc(@RequestParam(value = "seas_code") String seas_code, Model model) {
        // System.out.println("seas_code" + seas_code);
        String seas_desc = dao.getSeasonsDesc(seas_code);
        Order ord = new Order();
        JSONObject js = new JSONObject();
        js.put("seas_desc", seas_desc);

        return js;
    }

    @RequestMapping(value = "getOrderModdata", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject showgetOrderModdata(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, Model model) {
        JSONObject order = dao.getOrderModdata(seas_code, serial);
        model.addAllAttributes(order);
        return order;
    }

    @RequestMapping(value = "/AddOrderModification", method = RequestMethod.POST)
    public @ResponseBody
    Order AddOrderModification(@RequestBody Order formdata, Model model) {
        //System.out.println("oreer========" + formdata.getSeas_code());
        System.out.println("formdata=======" + formdata);
        //System.out.println("colour code=======" + formdata.getChoices().toString());
        String res = dao.saveOrderModify(formdata);
        System.out.println("Record added===========" + res);
        System.out.println("model=====" + model);

        return formdata;
    }

    @RequestMapping(value = "getColours", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject showColours(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, Model model) {

        JSONObject js = new JSONObject();
        js.put("colourList", dao.getColours(seas_code, serial));

        return js;
    }

    @RequestMapping(value = "/SizePriceEntry", method = RequestMethod.GET)
    public String showSizePriceEntry(Model model) {
        Order ord = new Order();
        model.addAttribute("command", ord);

        return "SizePriceEntry";
    }

    @RequestMapping(value = "getSizePriceData", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject showSizePriceData(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour_code") int colour_code, Model model) {

     // JSONObject js=new JSONObject();
        // js.put("sizepricedata",dao.getSizePriceData(seas_code, serial,colour_code));
        return dao.getSizePriceData(seas_code, serial, colour_code);
    }

    @RequestMapping(value = "/saveSizePriceData", method = RequestMethod.POST)
    public @ResponseBody
    JSONObject saveSizePriceData(@RequestBody Order formdata, Model model) {
        JSONObject js = new JSONObject();
       
       
            int res = dao.saveSizePriceData(formdata);

            if (res == 1) {
                js.put("msg", "Size Price data has been saved");
            } else {
                js.put("msg", "Size Price data not saved");
            }
       
        return js;
    }
    
    @RequestMapping(value = "/POEntry", method = RequestMethod.GET)
    public String showPOEntry(Model model) {
        Order ord = new Order();
        model.addAttribute("command", ord);

        return "POEntry";
    }
    
 @RequestMapping(value = "getSizeQtyData", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
   JSONObject showgetSizeQtyData(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour_code") int colour_code, Model model) {

    //  JSONObject js=new JSONObject();
     //  js.put("sizeqtydata",po.getSizeQtyData(seas_code, serial,colour_code));
       //po.getSizeQtyData(seas_code, serial, colour_code);
        return po.getSizeQtyData(seas_code, serial,colour_code);
    }
    
     @RequestMapping(value = "/saveSizeQtyPOData", method = RequestMethod.POST)
    public @ResponseBody
    JSONObject saveSizeQtyPOData(@RequestBody Order formdata, Model model) {
        JSONObject js = new JSONObject();
        return po.saveSizeQtyPOData(formdata);
    }

   }
