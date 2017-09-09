/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Controller;

import com.rmx.clientapp.CatalogDao;
import com.rmx.clientapp.Model.Order;
import java.util.List;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class CatalogController
{
    @Autowired
    CatalogDao catdao;
    
    @RequestMapping(value="CatalogEntry",method=RequestMethod.GET)
    public String showCatalogEntry(Model model)
    {
        model.addAttribute("command",new Order());
        return "CatalogEntry";
    }
    @RequestMapping(value="CatalogView",method=RequestMethod.GET)
    public String showCatalogView(Model model)
    {
       // model.addAttribute("command",new Order());
        return "CatalogView";
    }
    
    @RequestMapping(value="checkCatalog",method=RequestMethod.GET)
    public @ResponseBody
    JSONObject checkCatalog(@RequestParam(value="cat_name") String cat_name)
    { 
        JSONObject js=catdao.checkCatalogName(cat_name);
        
        return js;
    }
     @RequestMapping(value="addCatalog",method=RequestMethod.GET)
    public @ResponseBody
    JSONObject addCatalog(@RequestParam(value="cat_name") String cat_name)
    { 
        int res=catdao.addCatalog(cat_name);
        JSONObject js=new JSONObject();
        js.put("res",res);
        
        return js;
    }
     @RequestMapping(value="getCatalog",method=RequestMethod.GET)
    public @ResponseBody   List addCatalog()   
    { 
        List js=catdao.getCatalog();
        System.out.println("Catalog list======="+js);
        return js;
    }
    
}
