package com.trieste.xmlvalidator;


import java.io.File;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;

public class XMLparser
{
    public static void main(String[] args){

        try {
            File inputFile = new File("datafiles/Assign_9_Q1.xml");
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            /*
            * this is a public abstract class DocumentBuilderFactory extends Object.
            * this Defines a factory API that enables applications to obtain a parser
            * that produces DOM object trees from XML documents.
            *
            *  DOM stands for "Document Object Model"
            *  The DOM represents the document as nodes and objects; that way,
            *  programming languages can interact with the page
            *
            * */
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(inputFile);

            // scl - start at the root element ...
            doc.getDocumentElement().normalize();
            System.out.println("Root element : " + doc.getDocumentElement().getNodeName());

            NodeList nList = doc.getElementsByTagName("contribution");
            System.out.println("------    B  E  G  I  N  ----------");

            // lets iterate thru the array of nodes  with a classic for loop
            // 3 components of for loop; initiation position; termination position; iterative step-amount (post-fix unary this case)
            for (int temp = 0; temp < nList.getLength(); temp++) {

                Node nNode = nList.item(temp);

                System.out.println("\nCompany :" + nNode.getNodeName());

                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;

                    // lets create a series of print line statements then correspond to our XML elements and any inner attribute and value pairs
                    System.out.println("Parent Company : "
                            + eElement.getAttribute("cname"));

                    System.out.println("Division : "
                            + eElement.getAttribute("cname2"));

                    System.out.println("Total Assets : "
                            + eElement.getElementsByTagName("totalassets").item(0).getTextContent());

                    System.out.println("Total Liabilities : "
                            + eElement
                            .getElementsByTagName("totalliab")
                            .item(0)
                            .getTextContent());

                    System.out.println("Cash : "
                            + eElement
                            .getElementsByTagName("cash")
                            .item(0)
                            .getTextContent());
                }
            }
            System.out.println("------    E   N   D   --------");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

