import java
import semmle.code.java.dataflow.DataFlow

class CurrentEntityRead extends Method {
    // string classname;
    CurrentEntityRead(){
        this.hasQualifiedName("org.cyberneko.html", "HTMLScanner$CurrentEntity","read")
    }

    // string getClassname(){
    //     result = classname
    // }

}

class Append extends Method {
    Append(){
        this.hasQualifiedName("org.apache.xerces.util", "XMLStringBuffer","append")
    }

}


//find all of the classes that are in some package that implement a method called read
// from Method m
// where m.hasName("read")
// //and m.getDeclaringType().getPackage().toString() = "org.cyberneko.html"
// and m.getDeclaringType().hasQualifiedName("org.cyberneko.html", "HTMLScanner$CurrentEntity" )
// select m

// from CurrentEntityRead c 
// select c, c.getClassname()

//source
// from MethodAccess m 
// where m.getMethod() instanceof CurrentEntityRead
// select m

//sink
// from MethodAccess m 
// where m.getMethod() instanceof Append
// select m

//local dataflow library usage
// from  MethodAccess source, MethodAccess sink
// where sink.getMethod() instanceof Append
// and source.getMethod() instanceof CurrentEntityRead
// and DataFlow::localFlow(DataFlow::exprNode(source), DataFlow::exprNode(sink.getArgument(0)))
// select source, sink

//global dataflow library usage
class OurConfig extends DataFlow::Configuration {
    OurConfig() { this = "OurConfig" }
    
    override predicate isSource(DataFlow::Node node) {
        exists(MethodAccess source | 
            source.getMethod() instanceof CurrentEntityRead
            and node.asExpr() = source )
    }
    
    override predicate isSink(DataFlow::Node node) {
        exists(MethodAccess sink | 
            sink.getMethod() instanceof Append
            and node.asExpr() = sink.getArgument(0) )
    }

    //will not work!
    // override  predicate isBarrier(DataFlow::Node node) {
    //     exists(EOFExpr e | node.asExpr() = e.getAnOperand())
    // }
    override predicate isBarrierGuard(DataFlow::BarrierGuard guard){
            guard instanceof CustomGuard
    }

}

class CustomGuard extends DataFlow::BarrierGuard{
    CustomGuard(){
        this instanceof EOFExpr
    }
    override predicate checks(Expr e, boolean branch){
        exists(Expr e1 | e1 = e) and branch = false
    }
}

class EOFExpr extends EQExpr {
    EOFExpr(){
        this.getAnOperand().(MinusExpr).getAChildExpr().(Literal).getValue() = "1"
    }
}


//debugging for comoponents of EOFExpr model
// from EOFExpr e
// where e.getFile().getBaseName() = "HTMLScanner.java"
// select e, e.getLeftOperand() ,  e.getRightOperand()

//final query
from OurConfig c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select source, sink
