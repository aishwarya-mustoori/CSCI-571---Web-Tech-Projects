import React from 'react';
import axios from 'axios';
import Card from "react-bootstrap/Card";
import BounceLoader from "react-spinners/BounceLoader";
import TextTruncate from 'react-text-truncate';
import { withRouter } from 'react-router-dom'

import Popup from "reactjs-popup";

import Row from 'react-bootstrap/Row'
import Container from 'react-bootstrap/Container'
import Col from 'react-bootstrap/Col'



import _ from "lodash";
import Sharepopup from './Sharepopup.js';
class HomeResultsGa extends React.Component {
    state = { results: [], isLoading: true, checked: null }
    async componentDidMount() {
    this.props.onToggle(true)

        var section = ""

        if(window.location.href.indexOf("/sports") >-1 ){
            section = "sport"
        }else if (window.location.href.indexOf("/world")>-1) {
                section = "world"
        }else if (window.location.href.indexOf("/politics")>-1){
            section = "politics"
        }else if(window.location.href.indexOf("/technology")>-1){
            section = "technology"
        }else if(window.location.href.indexOf("/business")>-1){
            section = "business"
        }
        else {
            section = "home"
        }
        var results1 =[]
        fetch(
            `https://mustoori.azurewebsites.net/sectionsg?section=`+section
        ).then(res => {
            return res.json();
          })
          .then(data => {
            results1 = data;
            this.setState({ results: data });
            this.setState({ isLoading: false })
          });


    }
    componentWillReceiveProps(props){

        var section = ""
        this.setState({ isLoading: true })
        if(window.location.href.indexOf("/sports") >-1 ){
            section = "sport"
        }else if (window.location.href.indexOf("/world")>-1) {
                section = "world"
        }else if (window.location.href.indexOf("/politics")>-1){
            section = "politics"
        }else if(window.location.href.indexOf("/technology")>-1){
            section = "technology"
        }else if(window.location.href.indexOf("/business")>-1){
            section = "business"
        }
        else {
            section = "home"
        }
        var results1 =[]
        fetch(
            `https://mustoori.azurewebsites.net/sectionsg?section=`+section
        ).then(res => {
            return res.json();
          })
          .then(data => {
            results1 = data;
            this.setState({ results: data });
            this.setState({ isLoading: false })
          });


    }
    handleChange = id => {
        this.props.history.push("/article?id=" + id);
        
        // this.props.onValue(false)

    };
    
    handleEventChange = function(e) {
        e.stopPropagation();
        e.stopPropagation();
    };

    render() {
        var res = this.state.results.response

        if (res != null && res.length != 0 && !this.state.isLoading && res.results!=null) {
            return res.results.map(result => {
                var section = result.sectionId
                var mainSection;
                var divStyle = {

                }
                if (section == "business") {
                    divStyle = {
                        backgroundColor: "deepskyblue",
                        color: "white",
                        marginRight: '0px',
                        paddingLeft: '0.4em',
                        paddingRight: '0.4em',
                        fontWeight: "bold",
                        borderRadius: "5px",
                        fontSize: '16px',
                        textAlign: "right",
                        whiteSpace: "noWrap"
                    }
                    mainSection = "BUSINESS"
                } else if (section == "world") {
                    divStyle = {
                        backgroundColor: "blueviolet",
                        color: "white",
                        marginRight: '0px',
                        paddingLeft: '0.4em',
                        paddingRight: '0.4em',
                        fontWeight: "bold",
                        borderRadius: "5px",
                        fontSize: '16px',
                        whiteSpace: "noWrap"
                    }
                    mainSection = "WORLD"
                }
                else if (section == "sport") {
                    divStyle = {
                        backgroundColor: "gold",
                        color: "black",
                        marginRight: '0px',
                        paddingLeft: '0.4em',
                        paddingRight: '0.4em',
                        fontWeight: "bold",
                        borderRadius: "5px",
                        fontSize: '16px',
                        whiteSpace: "noWrap"
                    }
                    mainSection = "SPORT"
                }
                else if (section == "technology") {
                    divStyle = {
                        backgroundColor: "yellowgreen",
                        color: "black",
                        marginRight: '0px',
                        paddingLeft: '0.4em',
                        paddingRight: '0.4em',
                        fontWeight: "bold",
                        borderRadius: "5px",
                        fontSize: '16px',
                        whiteSpace: "noWrap"
                    }
                    mainSection = "TECHNOLOGY"
                }
                else if (section == "politics") {

                    mainSection = "POLITICS"
                    divStyle = {
                        backgroundColor: "darkcyan",
                        color: "white",
                        marginRight: '0px',
                        paddingLeft: '0.4em',
                        paddingRight: '0.4em',
                        fontWeight: "bold",
                        borderRadius: "5px",
                        fontSize: '16px',
                        whiteSpace: "noWrap"
                    }
                } else {

                    divStyle = {
                        backgroundColor: "grey",
                        color: "white",
                        marginRight: '0px',
                        paddingLeft: '0.4em',
                        paddingRight: '0.4em',
                        fontWeight: "bold",
                        borderRadius: "5px",
                        fontSize: '16px',
                        whiteSpace: "noWrap"

                    }
                    if(section!=null){
                        mainSection = section.toUpperCase();
                        }
                }
                var date = ""
                if(result.webPublicationDate!=null){
                    date=result.webPublicationDate.split("T")[0]
                }
                
                var url;
                if (result.blocks != null && result.blocks.main != null
                    && result.blocks.main.elements != null && result.blocks.main.elements[0] != null && result.blocks.main.elements[0].assets != null && result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length-1] != null && result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length-1].file != null) {
                    url = result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length-1].file
                }
                else {
                    url = 'https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png'
                }
                var text = "";
                if( result.blocks != null && result.blocks.body != null && result.blocks.body[0] != null && result.blocks.body[0].bodyTextSummary!= null){
                    text = result.blocks.body[0].bodyTextSummary
                }
                return (
                    <Card style={{ boxShadow: '4px 4px 8px 4px rgba(192,192,192,0.6)', margin: '3%',padding :'0.8%'}} onClick = {()=>this.handleChange(result.id)}>
                        <div  >
                            <Container fluid >
                                <Row xs={1} md={1} lg={2} sm={1} xl={2}>
                                    <Col xl={3} lg={3} md={3} style = {{padding:'0px'}}>
                                        
                                        <div className="img" style={{ padding:'1.5%', height :'100%',width: '100%',border: "1px solid  lightgrey" }}>
                                            <Card.Img src={url} style = {{width :'100%',height:'100%'}}  ></Card.Img>
                                        </div>
                                        
                                    </Col>
                                    <Col xl={9} lg={9} md={9}>
                                        <div className="Data" style={{ width: "100%" }}>
                                            <Card.Title style={{ fontWeight: 'bold', width: '100%',fontSize :'18px',marginTop :'0px'}}>
                                                <div>
                                                <i>{result.webTitle}</i>
                                               
                                                <span onClick ={this.handleEventChange} >
                                                    <Sharepopup title={result.webTitle} url={result.webUrl} />
                                
                                                </span> </div></Card.Title>

                                                

                                            <Card.Text style = {{fontSize : '16px'}}> <TextTruncate line={3} truncateText="…" text={text}></TextTruncate>

                                            </Card.Text>
                                            <div style={{ display: "flex", width: '100%' }}>
                                                <div style={{ width: "100%",fontSize :'16px' ,paddingBottom:'2%'}}>
                                                    <Card.Text><i>{date}</i></Card.Text>
                                                </div>
                                                <div>
                                                    <Card.Text style={divStyle}>{mainSection}</Card.Text>
                                                </div>
                                            </div>
                                        </div>
                                    </Col>
                                </Row>
                            </Container>
                        </div>
                    </Card>
                );
            })
        }
        else if (this.state.isLoading) {
            return (
                <center>
                    <div style={{ marginTop: '20%' }}>

                        <BounceLoader size="3.5em" color="darkblue" />
                        <h3>Loading</h3>
                    </div>
                </center>
            )
        }
        else return <div></div>
    }
}
export default withRouter(HomeResultsGa)