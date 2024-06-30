
<%@page import="PackChain.NoobChain"%>
<%@page import="PackChain.Block"%>
<%@page import="com.example.blockchain.CODE_ALGORITHM.AES"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="Connection.dbconnection"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Iterator"%>
<%
    dbconnection con = new dbconnection();
    String key = request.getParameter("key").trim();
    System.out.println(key);
    if (key.equals("login")) {
        String info = "";
        String qry = "select *from `login` where name='" + request.getParameter("uname") + "'and pass='" + request.getParameter("pass") + "' and status='1'";
        System.out.println("qry=" + qry);
        Iterator it = con.getData(qry).iterator();
        if (it.hasNext()) {
            Vector v = (Vector) it.next();
            info = v.get(3) + "#" + v.get(5) + "#" + v.get(2);
            System.out.println("yes id=" + info);
            out.print(info);
        } else {
            System.out.println("else id=" + info);
            out.print("failed");
        }
    }
    if (key.equals("UserReg")) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yy");
        String addres = formatter.format(date);
        String phone = request.getParameter("phone");
        String pass = request.getParameter("pass");
        String qry = "INSERT INTO `userreg`(`name`,`email`,`addres`,`phone`,`pass`) VALUES ('" + name + "','" + email + "','" + addres + "','" + phone + "','" + pass + "')";
        String qry1 = "insert into login (name,pass,type,status,uid)values('" + email + "','" + pass + "','user','0',(select max(uid)from userreg))";
        if (con.putData(qry) > 0 && con.putData(qry1) > 0) {
            out.print("successful");
        } else {
            out.print("failed");
        }
    }
    //alt+shit+f getuserToApprove
    if (key.equals("getuserToApprove")) {
        JSONArray array = new JSONArray();
        String qry = "SELECT `userreg`.*,`login`.`status` FROM `login`,`userreg` WHERE `userreg`.`uid`=`login`.`uid` ";
        System.out.println("qry=" + qry);
        Iterator it = con.getData(qry).iterator();
        if (it.hasNext()) {

            while (it.hasNext()) {
                Vector v = (Vector) it.next();
                JSONObject obj = new JSONObject();
                obj.put("uid", v.get(0).toString().trim());
                obj.put("name", v.get(1).toString().trim());
                obj.put("email", v.get(2).toString().trim());
                obj.put("phone", v.get(3).toString().trim());
                obj.put("userdate", v.get(4).toString().trim());
                obj.put("status", v.get(6).toString().trim());
                System.out.println(v.get(6));
                array.add(obj);
            }
            out.println(array);
        } else {
            System.out.println("else id");
            out.print("failed");
        }
    }

//blockuserlist
    if (key.equals("rejectdata")) {
        String id = request.getParameter("userid");

        String qry = "update login set status='n' where uid='" + id + "'";
        if (con.putData(qry) > 0) {
            out.print("successful");
        } else {
            out.print("failed");
        }
    }
    //Acceptuserlist

    if (key.equals("approvedata")) {
        String id = request.getParameter("userid");

        String qry = "update login set status='1' where uid='" + id + "'";
        if (con.putData(qry) > 0) {
            out.print("successful");
        } else {
            out.print("failed");
        }
    }
    
  //alt+shit+f getuserToApprove
    if (key.equals("getalluserdataonly")) {
        String uu=request.getParameter("uid");
        JSONArray array = new JSONArray();
        String qry = "SELECT `userreg`.*,`login`.`status` FROM `login`,`userreg` WHERE `userreg`.`uid`=`login`.`uid` AND `login`.`type`='user' AND `login`.`status`='1' and `userreg`.`uid`!='"+uu+"'";
        System.out.println("qry=" + qry);
        Iterator it = con.getData(qry).iterator();
        if (it.hasNext()) {

            while (it.hasNext()) {
                Vector v = (Vector) it.next();
                JSONObject obj = new JSONObject();
                obj.put("uid", v.get(0).toString().trim());
                obj.put("name", v.get(1).toString().trim());
                obj.put("phone", v.get(4).toString().trim());
                System.out.println(v.get(6));
                array.add(obj);
            }
            System.out.println(array);
            out.println(array);
        } else {
            System.out.println("else id");
            out.print("failed");
        }
    }
    //sendmessage
      if (key.equals("sendmessage")) {
          
        String keyvalu = request.getParameter("keyvalu");
        String image = request.getParameter("image");
         String messaged = request.getParameter("message");
        String userid = request.getParameter("userid");
         String touser = request.getParameter("touser");

             String message = AES.encrypt(messaged, "secretKey");

        String qry = "INSERT INTO `sendmessage`(`userid`,`touser`,`keyvalu`,`message`,image) VALUES ('" + userid + "','" + touser + "','" + keyvalu + "','" + message + "','" + image + "')";
        if (con.putData(qry) > 0) {
            System.out.println("ywes insert");
            out.print("successful");
        } else {
            out.print("failed");
        }
    }
       //Feedback
      if (key.equals("Feedback")) {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        
         String star = request.getParameter("star");
        String uid = request.getParameter("uid");

        String qry = "INSERT INTO `feedback`(`uid`,`title`,`description`,`star`) VALUES ('" + uid + "','" + title + "','" + description + "','" + star + "')";
        if (con.putData(qry) > 0) {
            System.out.println("ywes insert");
            out.print("successful");
        } else {
            out.print("failed");
        }
    }
      
//feedback
    //alt+shit+f getuserToApprove
    if (key.equals("getallfeedbacks")) {
        JSONArray array = new JSONArray();
        String qry = "SELECT *FROM `feedback`,`userreg`  WHERE `userreg`.`uid`=`feedback`.`uid`";
        System.out.println("qry=" + qry);
        Iterator it = con.getData(qry).iterator();
        if (it.hasNext()) {

            while (it.hasNext()) {
                Vector v = (Vector) it.next();
                JSONObject obj = new JSONObject();
                obj.put("uid", v.get(0).toString().trim());
                obj.put("name", v.get(6).toString().trim());
                obj.put("email", v.get(9).toString().trim());
                obj.put("phone", v.get(2).toString().trim());
                obj.put("userdate", v.get(3).toString().trim());
                obj.put("status", v.get(4).toString().trim());
                System.out.println(v.get(6));
                array.add(obj);
            }
            out.println(array);
        } else {
            System.out.println("else id");
            out.print("failed");
        }
    }
    //getprofilre
        if (key.equals("getaprofuile")) {
        String info = "";
                String uid = request.getParameter("uid");

        String qry = "select *from `userreg` where uid='"+uid+"'";
        System.out.println("qry=" + qry);
        Iterator it = con.getData(qry).iterator();
        if (it.hasNext()) {
            Vector v = (Vector) it.next();
            info = v.get(1) + "#" + v.get(2) + "#" + v.get(3)+ "#" + v.get(4) + "#" + v.get(5);
            System.out.println("yes id=" + info);
            out.print(info);
        } else {
            System.out.println("else id=" + info);
            out.print("failed");
        }
    }
        //update
        if (key.equals("updateprofile")) {
        String NAME = request.getParameter("NAME");
        String uid = request.getParameter("uid");
        String email = request.getParameter("email").toString();
        String phone = request.getParameter("phone");
        String dates = request.getParameter("dates");
           String pass = request.getParameter("pass");

        String updateqry = "UPDATE userreg SET name='" + NAME + "',email='" + email + "',addres='" + dates + "',phone='" + phone + "',pass='" + pass + "' where uid='" + uid + "'";
        String updatelogin = "UPDATE login SET name='" + email + "' ,  pass='" + pass + "' where uid='" + uid + "'";

        int rs = con.putData(updateqry);
        int rss = con.putData(updatelogin);

        if (rs > 0 && rss > 0) {
            System.out.print("sucess");
            out.print("sucess");

        } else {
            out.print("failed");
                        System.out.println(updateqry);

            System.out.println(updatelogin);
            System.out.print("faield");
        }

    }
        
  //getprofilre
        if (key.equals("getimagedata")) {
        String info = "";
                String uid = request.getParameter("uid");
                String Searchkeyvalue = request.getParameter("Searchkeyvalue");
                           // String Searchkeyvalue="xV7i1yCIA+ZohuYhP+/iXg==";xV7ilyCIA+ZohuYhP+/iXg==
                 System.out.println("Key :-------------->"+Searchkeyvalue);

        String qry = "SELECT `sendmessage`.* FROM `sendmessage` WHERE `sendmessage`.`keyvalu`='"+Searchkeyvalue+"' AND `sendmessage`.`userid`!='"+uid+"'";
        System.out.println("qry=" + qry);
        Iterator it = con.getData(qry).iterator();
        if (it.hasNext()) {
            Vector v = (Vector) it.next();
                        String message = AES.decrypt(v.get(4).toString() , "secretKey");

            info = v.get(4) + "#" + v.get(5) + "#"+message+"#";
            System.out.println("yes id=" + info);
            out.print(info);
            System.out.println("GOING...."+info);
        } else {
            System.out.println("else id=" + info);
            out.print("failed");
        }
    }
%>