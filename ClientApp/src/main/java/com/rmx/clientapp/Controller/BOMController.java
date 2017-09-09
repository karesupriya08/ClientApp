/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Controller;

import com.rmx.clientapp.Model.BOM;
import com.rmx.clientapp.Model.Order;
import com.rmx.clientapp.Model.Season;
import com.rmx.clientapp.QueryDao;
import java.io.IOException;
import java.text.ParseException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BOMController {

    @Autowired
    QueryDao qdao;

    @RequestMapping(value = "BomPoQuery", method = RequestMethod.GET)
    public String showBomPOJSP(Model model) {
        return "BomPoQuery";
    }

    @RequestMapping(value = "getBuyerCode", method = RequestMethod.GET)
    public @ResponseBody
    List getBuyerCodeList(@RequestParam(value = "seas_code") String seas_code) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getBuyerCode_List(seas_code);
    }

    @RequestMapping(value = "getStyleNo", method = RequestMethod.GET)
    public @ResponseBody
    List getStyleNoList(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "mode") String mode) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getStyleNo_List(seas_code, buyer_code, mode);
    }

    @RequestMapping(value = "getControlData", method = RequestMethod.GET)
    public @ResponseBody
    List getControlData(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "mode") String mode, @RequestParam(value = "style_no") String style_no) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getColourControl_List(seas_code, buyer_code, mode, style_no);
    }

    @RequestMapping(value = "getsizeBomdata", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject getsizeBomdata(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour, @RequestParam(value = "mode") String mode, @RequestParam(value = "buyer_code") String buyer_code, Model model) throws ParseException {
        model.addAttribute("seas_code", seas_code);
        ModelMap model1 = new ModelMap();
        model1.put("seas_code", 23);
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getsizeBom_List(seas_code, serial, colour, mode, buyer_code);
    }

    @RequestMapping(value = "getFabRate", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject getFabRate(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour, @RequestParam(value = "mode") String mode, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "style_no") String style_no) throws ParseException {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getFabRate(seas_code, serial, colour, mode, buyer_code, style_no);
    }

    @RequestMapping(value = "getIssueDetail", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject getIssueDetail(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour, @RequestParam(value = "mode") String mode, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "style_no") String style_no, @RequestParam(value = "itemcode") List itemcode) throws ParseException {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        System.out.println("itemcode---------------" + itemcode);
        return qdao.getIssueDetail(seas_code, serial, colour, mode, buyer_code, style_no, itemcode);
    }

    @RequestMapping(value = "getFOC", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject getFOC(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour, @RequestParam(value = "mode") String mode, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "style_no") String style_no, @RequestParam(value = "itemcode") List itemcode) throws ParseException {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
        //System.out.println("itemcode---------------"+itemcode);
        return qdao.getFOC(seas_code, serial, colour, mode, buyer_code, style_no, itemcode);
    }

    @RequestMapping(value = "getImport", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject getImport(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour, @RequestParam(value = "mode") String mode, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "style_no") String style_no, @RequestParam(value = "itemcode") List itemcode) throws ParseException {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
        //System.out.println("itemcode---------------"+itemcode);
        return qdao.getImport(seas_code, serial, colour, mode, buyer_code, style_no, itemcode);
    }

    @RequestMapping(value = "getprint", method = RequestMethod.POST, produces = {"text/xml"})
    public void getprint(@RequestBody BOM bom, Model model, HttpServletRequest req, HttpServletResponse res) throws ParseException, ServletException, IOException {
          //JSONObject js= qdao.getBuyerCode_List(seas_code);
          /* System.out.println("itemcode---------------"+seas_code);  System.out.println("itemcode---------------"+colour);
         System.out.println("itemcode---------------"+itemcode);
         System.out.println("itemcode---------------");*/
        // model.addAttribute("seas_code", 51);
        System.out.println("bomdata ----------------------" + bom.getBomdata());
        System.out.println("size ----------------------" + bom.getStylenolist());
        System.out.println("getOrder_qty ----------------------" + bom.getOrder_qty());
        System.out.println("getB_style ----------------------" + bom.getB_style());
        model.addAttribute("b_style", bom.getB_style());
        model.addAttribute("stylenolist", bom.getStylenolist());
        model.addAttribute("bomdata", bom.getBomdata());
        RequestDispatcher r = req.getServletContext().getRequestDispatcher("/jsp/viewemp.jsp");
        r.forward(req, res);
      //  return    "/viewemp";
        // return new ModelAndView("viewemp");
        // return "redirect:/viewemp";
        // return qdao.getImport(seas_code,serial,colour,mode,buyer_code,style_no,itemcode);
    }

    @RequestMapping(value = "BOMEntry", method = RequestMethod.GET)
    public String showBOMEntry(Model model) {
        return "BOMEntry";
    }

    @RequestMapping(value = "getSerialBomEntry", method = RequestMethod.GET)
    public @ResponseBody
    List getSerialBomEntry(@RequestParam(value = "seas_code") String seas_code) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getSerial(seas_code);
    }

    @RequestMapping(value = "getColourBom", method = RequestMethod.GET)
    public @ResponseBody
    List getColourBom(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getColour(seas_code, serial);
    }

    @RequestMapping(value = "getBomDetails", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject getBomDetails(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "serial") int serial, @RequestParam(value = "colour") int colour, Model model) {

        // JSONObject js=new JSONObject();
        // js.put("sizepricedata",dao.getSizePriceData(seas_code, serial,colour_code));
        return qdao.getBomDetails(seas_code, serial, colour);
    }

    @RequestMapping(value = "getBOMAddNew", method = RequestMethod.GET)
    public String getBOMAddNew(@RequestParam(value = "part") String part, @RequestParam(value = "seas_code") String seas_code, Model model) {
        System.out.println("part----------" + part);
        model.addAttribute("seas_code", seas_code);
        model.addAttribute("part", part);
        return "BOMAddNew";
    }

    @RequestMapping(value = "/getCodeList", method = RequestMethod.GET)
    public @ResponseBody
    List populateCodeList(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "part") String part, Model model) {
        // List seasonList = dao.getAllSeasonsCode();
        System.out.println("code----------" + seas_code);
       // List codeList = qdao.getCodeList(seas_code);
        // model.addAttribute(codeList);
        return qdao.getCodeList(seas_code, part);
        //System.out.println("seasonList========"+seasonList);

    }

    @RequestMapping(value = "getFabGreyCode", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject getFabGreyCode(@RequestParam(value = "fabcode") String fabcode) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getFabGreyCode(fabcode);
    }

    @RequestMapping(value = "getColoursAll", method = RequestMethod.GET)
    public @ResponseBody
    List getColoursAll() {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getColourList();
    }

    @RequestMapping(value = "getCatalogList", method = RequestMethod.GET)
    public @ResponseBody
    List getCatalogList() {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getCatalogList();
    }

    @RequestMapping(value = "getUOMList", method = RequestMethod.GET)
    public @ResponseBody
    List getUOMList() {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getUOMList();
    }

    @RequestMapping(value = "getbasecodelist", method = RequestMethod.GET)
    public @ResponseBody
    List getbasecodelist(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "part") String part, Model model) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        System.out.println("model-----------" + model.toString());
        return qdao.getbasecodelist(seas_code, part);
    }

    @RequestMapping(value = "checkitemcode", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject checkitemcode(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "part") String part, @RequestParam(value = "colour") int colour, @RequestParam(value = "serial") int serial, @RequestParam(value = "code") String code, @RequestParam(value = "colour_code") String colour_code, Model model) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        System.out.println("model-----------" + model.toString());
        return qdao.checkitemcode(seas_code, part, colour, serial, code, colour_code);
    }

    @RequestMapping(value = "checkcatalog", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject checkcatalog(@RequestParam(value = "code") String code, @RequestParam(value = "catalog") String catalog, @RequestParam(value = "part") String part, Model model) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.checkcatalog(code, catalog, part);
    }

    @RequestMapping(value = "checkFabCode", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject checkFabCode(@RequestParam(value = "fabcode") String code, @RequestParam(value = "part") String part, @RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "colour") int colour, @RequestParam(value = "serial") int serial, HttpSession session, Model model) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.checkFabCode(code, part, seas_code, colour, serial, session);
    }

    @RequestMapping(value = "getBOMdata", method = RequestMethod.GET)
    public @ResponseBody
    List getBOMdata(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "part") String part, @RequestParam(value = "colour") int colour, @RequestParam(value = "serial") int serial, Model model) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        System.out.println("model-----------" + model.toString());
        return qdao.getBOMdata(seas_code, part, colour, serial);
    }

    @RequestMapping(value = "saveBomAddNewData", method = RequestMethod.POST, produces = {"application/xml", "application/json"})
    public JSONObject saveBomAddNewData(@RequestBody JSONObject formdata, Model model) {
        System.out.println("formdata-------------" + formdata.toJSONString());
        System.out.println("aaa" + formdata.get("uom"));
        return qdao.saveBomAddNewData(formdata);
    }

    @RequestMapping(value = "getBOMCopydata", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject getBOMCopydata(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "part") String part, @RequestParam(value = "colour") int colour, @RequestParam(value = "serial") int serial, Model model) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        System.out.println("model-----------" + model.toString());
        return qdao.getBOMCopydata(seas_code, part, colour, serial);
    }

    @RequestMapping(value = "getColourListAll", method = RequestMethod.GET)
    public @ResponseBody
    List getColourListAll(Model model) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        System.out.println("model-----------" + model.toString());
        return qdao.getColourListAll();
    }

    @RequestMapping(value = "saveCopyData", method = RequestMethod.POST, produces = {"application/xml", "application/json"})
    public JSONObject saveCopyData(@RequestBody JSONObject formdata) {
        System.out.println("formadaata-------------" + formdata.toJSONString());
        return qdao.saveCopyData(formdata);
    }

    @RequestMapping(value = "BOMApprovedModule", method = RequestMethod.GET)
    public String BOMApprovedModule(Model model) {
        return "BOMApprovedModule";
    }

    @RequestMapping(value = "getBomappdata", method = RequestMethod.GET, produces = {"application/xml", "application/json"})
    public @ResponseBody
    JSONObject getBomappdata(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "style_no") String style_no, @RequestParam(value = "buyer_code") String buyer_code, @RequestParam(value = "fabradio") String fabradio, Model model) {
        return qdao.getBomappdata(seas_code, style_no, buyer_code, fabradio);
    }

    @RequestMapping(value = "BOM4", method = RequestMethod.GET)
    public String BOM4(Model model) {
        return "BOM4";
    }
     @RequestMapping(value = "/getCodeListforBom4", method = RequestMethod.GET)
    public @ResponseBody
    List getCodeListforBom4(@RequestParam(value = "seas_code") String seas_code,  Model model) {
       
        return qdao.getCodeListforBom4(seas_code);
      

    }
    @RequestMapping(value = "getStyleNoList", method = RequestMethod.GET)
    public @ResponseBody
    List getStyleNoListBOM4(@RequestParam(value = "seas_code") String seas_code, @RequestParam(value = "buyer_code") String buyer_code) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getStyleNoListBOM4(seas_code, buyer_code);
    }
     @RequestMapping(value = "checkItemCode", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject checkItemCode(@RequestParam(value = "item_code") String item_code,  @RequestParam(value = "seas_code") String seas_code, Model model) {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.checkItemCodeBOM4(item_code , seas_code);
    }
     @RequestMapping(value = "getColourBom4", method = RequestMethod.GET)
    public @ResponseBody
    List getColourBom4() {
        //JSONObject js= qdao.getBuyerCode_List(seas_code);
        return qdao.getColourBom4();
    }
}
