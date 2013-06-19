require 'savon'
require 'nokogiri'

class DataUpdater
  include Singleton

  def initialize
    @client = Savon.client(wsdl: 'http://www.webservicex.net/country.asmx?WSDL')
    # @client = Savon::Client.new do
    #   wsdl.document = "http://www.webservicex.net/country.asmx?WSDL"
    # end
  end

  def update
    response = get_soap_response
    return nil if response.nil?

    data = parse_response(response)
    data.keys.each do |key| 
      data[key].each do |attributes|
        object = key.to_s.classify.constantize.find_or_create_by_code(attributes)
        
      end
    end
  end

  private
  def get_soap_response
    begin
      response = (defined?(USE_STATIC_DATA) && USE_STATIC_DATA) ? StaticSOAPResponse.new : @client.request(:get_currencies)
    rescue Exception => e
      Rails.logger.error "Error retrieving SOAP Response: '#{e.message}'"
      e.backtrace.each {|line| Rails.logger.error "- #{line}" }
      return nil
    end
  end

  # Returns a Hash with the following structure:
  #   { :currencies => [
  #       { :name => "Currency Name",
  #         :code => "Currency Code",
  #         :country_code => "Country Code"
  #       }
  #     ],
  #     
  #     :countries => [
  #       { :name => "Country Name",
  #         :code => "Country Code"
  #       }
  #     ]
  #   }
  def parse_response( response = get_soap_response )
    doc = Nokogiri::XML::Document.parse( response.to_hash[:get_currencies_response][:get_currencies_result] )

    result = {}
    
    result[:currencies] = doc.css('Table').collect do |table|
      { :name => table.css('Currency').text,
        :code => table.css('CurrencyCode').text,
        :country_id => table.css('CountryCode').text
      }
    end
    
    result[:countries] = doc.css('Table').collect {|table| { :name => table.css('Name').text, :code => table.css('CountryCode').text } }

    result.keys.each {|key| result[key].reject! {|hash| hash[:name].blank? || hash[:code].blank? } }

    result
  end

  # Used in development mode, as the web service is not reliable.
  class StaticSOAPResponse
    def to_hash
      {:get_currencies_response=>{:get_currencies_result=>"<NewDataSet>\n  <Table>\n    <Name>Afghanistan, Islamic State of</Name>\n    <CountryCode>af</CountryCode>\n    <Currency>Afghani</Currency>\n    <CurrencyCode>AFA</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Albania</Name>\n    <CountryCode>al</CountryCode>\n    <Currency>Lek</Currency>\n    <CurrencyCode>ALL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Algeria</Name>\n    <CountryCode>dz</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>DZD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>American Samoa</Name>\n    <CountryCode>as</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Andorra, Principality of</Name>\n    <CountryCode>ad</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>ADF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Angola</Name>\n    <CountryCode>ao</CountryCode>\n    <Currency>New Kwanza</Currency>\n    <CurrencyCode>AON</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Anguilla</Name>\n    <CountryCode>ai</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Antarctica</Name>\n    <CountryCode>aq</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Antigua and Barbuda</Name>\n    <CountryCode>ag</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Argentina</Name>\n    <CountryCode>ar</CountryCode>\n    <Currency>Peso </Currency>\n    <CurrencyCode>ARS</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Armenia</Name>\n    <CountryCode>am</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Aruba</Name>\n    <CountryCode>aw</CountryCode>\n    <Currency>Florin </Currency>\n    <CurrencyCode>AWG</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Australia</Name>\n    <CountryCode>au</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>AUD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Austria</Name>\n    <CountryCode>at</CountryCode>\n    <Currency>Schilling</Currency>\n    <CurrencyCode>ATS</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Azerbaidjan</Name>\n    <CountryCode>az</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Bahamas</Name>\n    <CountryCode>bs</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>BSD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Bahrain</Name>\n    <CountryCode>bh</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>BHD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Bangladesh</Name>\n    <CountryCode>bd</CountryCode>\n    <Currency>Taka</Currency>\n    <CurrencyCode>BDT</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Barbados</Name>\n    <CountryCode>bb</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>BBD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Belarus</Name>\n    <CountryCode>by</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Belgium</Name>\n    <CountryCode>be</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>BEF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Belize</Name>\n    <CountryCode>bz</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>BZD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Benin</Name>\n    <CountryCode>bj</CountryCode>\n    <Currency>CFA Franc </Currency>\n    <CurrencyCode>XOF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Bermuda</Name>\n    <CountryCode>bm</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>BMD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Bhutan</Name>\n    <CountryCode>bt</CountryCode>\n    <Currency>Ngultrum</Currency>\n    <CurrencyCode>BTN</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Bolivia</Name>\n    <CountryCode>bo</CountryCode>\n    <Currency>Boliviano</Currency>\n    <CurrencyCode>BOB</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Bosnia-Herzegovina</Name>\n    <CountryCode>ba</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Botswana</Name>\n    <CountryCode>bw</CountryCode>\n    <Currency>Pula</Currency>\n    <CurrencyCode>BWP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Bouvet Island</Name>\n    <CountryCode>bv</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Brazil</Name>\n    <CountryCode>br</CountryCode>\n    <Currency>Cruzeiro</Currency>\n    <CurrencyCode>BRC</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>British Indian Ocean Territory</Name>\n    <CountryCode>io</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Brunei Darussalam</Name>\n    <CountryCode>bn</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>BND</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Bulgaria</Name>\n    <CountryCode>bg</CountryCode>\n    <Currency>Lev</Currency>\n    <CurrencyCode>BGL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Burkina Faso</Name>\n    <CountryCode>bf</CountryCode>\n    <Currency>CFA Franc </Currency>\n    <CurrencyCode>XOF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Burundi</Name>\n    <CountryCode>bi</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>BIF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Cambodia, Kingdom of</Name>\n    <CountryCode>kh</CountryCode>\n    <Currency>Riel </Currency>\n    <CurrencyCode>KHR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Cameroon</Name>\n    <CountryCode>cm</CountryCode>\n    <Currency>CFA Franc </Currency>\n    <CurrencyCode>XAF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Canada</Name>\n    <CountryCode>ca</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>CAD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Cape Verde</Name>\n    <CountryCode>cv</CountryCode>\n    <Currency>Escudo</Currency>\n    <CurrencyCode>CVE</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Cayman Islands</Name>\n    <CountryCode>ky</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>KYD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Central African Republic</Name>\n    <CountryCode>cf</CountryCode>\n    <Currency>CFA Franc </Currency>\n    <CurrencyCode>XAF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Chad</Name>\n    <CountryCode>td</CountryCode>\n    <Currency>CFA Franc BEAC</Currency>\n    <CurrencyCode>XAF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Chile</Name>\n    <CountryCode>cl</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>CLP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>China</Name>\n    <CountryCode>cn</CountryCode>\n    <Currency>Yuan Renminbi</Currency>\n    <CurrencyCode>CNY</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Christmas Island</Name>\n    <CountryCode>cx</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Cocos (Keeling) Islands</Name>\n    <CountryCode>cc</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Colombia</Name>\n    <CountryCode>co</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>COP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Comoros</Name>\n    <CountryCode>km</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>KMF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Congo</Name>\n    <CountryCode>cg</CountryCode>\n    <Currency>CFA Franc BEAC</Currency>\n    <CurrencyCode>XAF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Congo, The Democratic Republic of the</Name>\n    <CountryCode>cd</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Cook Islands</Name>\n    <CountryCode>ck</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Costa Rica</Name>\n    <CountryCode>cr</CountryCode>\n    <Currency>Colon</Currency>\n    <CurrencyCode>CRC</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Croatia</Name>\n    <CountryCode>hr</CountryCode>\n    <Currency>Kuna</Currency>\n    <CurrencyCode>HRK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Cuba</Name>\n    <CountryCode>cu</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>CUP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Cyprus</Name>\n    <CountryCode>cy</CountryCode>\n    <Currency>Pound</Currency>\n    <CurrencyCode>CVP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Czech Republic</Name>\n    <CountryCode>cz</CountryCode>\n    <Currency>Koruna</Currency>\n    <CurrencyCode>CSK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Denmark</Name>\n    <CountryCode>dk</CountryCode>\n    <Currency>Guilder</Currency>\n    <CurrencyCode>DKK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Djibouti</Name>\n    <CountryCode>dj</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>DJF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Dominica</Name>\n    <CountryCode>dm</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>DOP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Dominican Republic</Name>\n    <CountryCode>do</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>DOP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>East Timor</Name>\n    <CountryCode>tp</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Ecuador</Name>\n    <CountryCode>ec</CountryCode>\n    <Currency>Sucre</Currency>\n    <CurrencyCode>ECS</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Egypt</Name>\n    <CountryCode>eg</CountryCode>\n    <Currency>Pound</Currency>\n    <CurrencyCode>EGP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>El Salvador</Name>\n    <CountryCode>sv</CountryCode>\n    <Currency>Colon</Currency>\n    <CurrencyCode>SVC</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Equatorial Guinea</Name>\n    <CountryCode>gq</CountryCode>\n    <Currency>CFA </Currency>\n    <CurrencyCode>XAF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Eritrea</Name>\n    <CountryCode>er</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Estonia</Name>\n    <CountryCode>ee</CountryCode>\n    <Currency>Kroon</Currency>\n    <CurrencyCode>EEK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Ethiopia</Name>\n    <CountryCode>et</CountryCode>\n    <Currency>Birr</Currency>\n    <CurrencyCode>ETB</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Falkland Islands</Name>\n    <CountryCode>fk</CountryCode>\n    <Currency>Pound</Currency>\n    <CurrencyCode>FKP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Faroe Islands</Name>\n    <CountryCode>fo</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Fiji</Name>\n    <CountryCode>fj</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>FJD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Finland</Name>\n    <CountryCode>fi</CountryCode>\n    <Currency>Markka</Currency>\n    <CurrencyCode>FIM</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Former Czechoslovakia</Name>\n    <CountryCode>cs</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Former USSR</Name>\n    <CountryCode>su</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>France</Name>\n    <CountryCode>fr</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>FRF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>France (European Territory)</Name>\n    <CountryCode>fx</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>French Guyana</Name>\n    <CountryCode>gf</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>French Southern Territories</Name>\n    <CountryCode>tf</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Gabon</Name>\n    <CountryCode>ga</CountryCode>\n    <Currency>CFA Franc BEAC</Currency>\n    <CurrencyCode>XAF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Gambia</Name>\n    <CountryCode>gm</CountryCode>\n    <Currency>Dalasi</Currency>\n    <CurrencyCode>GMD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Georgia</Name>\n    <CountryCode>ge</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Germany</Name>\n    <CountryCode>de</CountryCode>\n    <Currency>Mark</Currency>\n    <CurrencyCode>DEM</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Ghana</Name>\n    <CountryCode>gh</CountryCode>\n    <Currency>Cedi</Currency>\n    <CurrencyCode>GHC</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Gibraltar</Name>\n    <CountryCode>gi</CountryCode>\n    <Currency>Pound</Currency>\n    <CurrencyCode>GIP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Great Britain</Name>\n    <CountryCode>gb</CountryCode>\n    <Currency>Sterling</Currency>\n    <CurrencyCode>GBP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Greece</Name>\n    <CountryCode>gr</CountryCode>\n    <Currency>Drachma</Currency>\n    <CurrencyCode>GRD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Greenland</Name>\n    <CountryCode>gl</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Grenada</Name>\n    <CountryCode>gd</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Guadeloupe (French)</Name>\n    <CountryCode>gp</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Guam (USA)</Name>\n    <CountryCode>gu</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Guatemala</Name>\n    <CountryCode>gt</CountryCode>\n    <Currency>Quetzal</Currency>\n    <CurrencyCode>GTQ</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Guinea</Name>\n    <CountryCode>gn</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>GNF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Guinea Bissau</Name>\n    <CountryCode>gw</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>GWP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Guyana</Name>\n    <CountryCode>gy</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>GYD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Haiti</Name>\n    <CountryCode>ht</CountryCode>\n    <Currency>Gourde</Currency>\n    <CurrencyCode>HTG</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Heard and McDonald Islands</Name>\n    <CountryCode>hm</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Holy See (Vatican City State)</Name>\n    <CountryCode>va</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Honduras</Name>\n    <CountryCode>hn</CountryCode>\n    <Currency>Lempira</Currency>\n    <CurrencyCode>HNL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Hong Kong</Name>\n    <CountryCode>hk</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>HKD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Hungary</Name>\n    <CountryCode>hu</CountryCode>\n    <Currency>Forint</Currency>\n    <CurrencyCode>HUF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Iceland</Name>\n    <CountryCode>is</CountryCode>\n    <Currency>Krona</Currency>\n    <CurrencyCode>ISK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>India</Name>\n    <CountryCode>in</CountryCode>\n    <Currency>Rupee</Currency>\n    <CurrencyCode>INR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Indonesia</Name>\n    <CountryCode>id</CountryCode>\n    <Currency>Rupiah</Currency>\n    <CurrencyCode>IDR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Iran</Name>\n    <CountryCode>ir</CountryCode>\n    <Currency>Rial</Currency>\n    <CurrencyCode>IRR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Iraq</Name>\n    <CountryCode>iq</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>IQD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Ireland</Name>\n    <CountryCode>ie</CountryCode>\n    <Currency>Punt</Currency>\n    <CurrencyCode>IEP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Israel</Name>\n    <CountryCode>il</CountryCode>\n    <Currency>New Shekel</Currency>\n    <CurrencyCode>ILS</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Italy</Name>\n    <CountryCode>it</CountryCode>\n    <Currency>Lira</Currency>\n    <CurrencyCode>ITL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Ivory Coast (Cote D'Ivoire)</Name>\n    <CountryCode>ci</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Jamaica</Name>\n    <CountryCode>jm</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>JMD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Japan</Name>\n    <CountryCode>jp</CountryCode>\n    <Currency>Yen</Currency>\n    <CurrencyCode>JPY</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Jordan</Name>\n    <CountryCode>jo</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>JOD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Kazakhstan</Name>\n    <CountryCode>kz</CountryCode>\n    <Currency>Tenge</Currency>\n    <CurrencyCode>KZT</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Kenya</Name>\n    <CountryCode>ke</CountryCode>\n    <Currency>Schilling</Currency>\n    <CurrencyCode>KES</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Kiribati</Name>\n    <CountryCode>ki</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Kuwait</Name>\n    <CountryCode>kw</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>KWD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Kyrgyz Republic (Kyrgyzstan)</Name>\n    <CountryCode>kg</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Laos</Name>\n    <CountryCode>la</CountryCode>\n    <Currency>Kip</Currency>\n    <CurrencyCode>LAK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Latvia</Name>\n    <CountryCode>lv</CountryCode>\n    <Currency>Lats</Currency>\n    <CurrencyCode>LVL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Lebanon</Name>\n    <CountryCode>lb</CountryCode>\n    <Currency>Pound</Currency>\n    <CurrencyCode>LBP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Lesotho</Name>\n    <CountryCode>ls</CountryCode>\n    <Currency>Loti</Currency>\n    <CurrencyCode>LSL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Liberia</Name>\n    <CountryCode>lr</CountryCode>\n    <Currency> Dollar</Currency>\n    <CurrencyCode>LRD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Libya</Name>\n    <CountryCode>ly</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>LYD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Liechtenstein</Name>\n    <CountryCode>li</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Lithuania</Name>\n    <CountryCode>lt</CountryCode>\n    <Currency>Litas</Currency>\n    <CurrencyCode>LTL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Luxembourg</Name>\n    <CountryCode>lu</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>LUF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Macau</Name>\n    <CountryCode>mo</CountryCode>\n    <Currency>Pataca</Currency>\n    <CurrencyCode>MOP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Macedonia</Name>\n    <CountryCode>mk</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Madagascar</Name>\n    <CountryCode>mg</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Malawi</Name>\n    <CountryCode>mw</CountryCode>\n    <Currency>Kwacha</Currency>\n    <CurrencyCode>MWK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Malaysia</Name>\n    <CountryCode>my</CountryCode>\n    <Currency>Ringgit</Currency>\n    <CurrencyCode>MYR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Maldives</Name>\n    <CountryCode>mv</CountryCode>\n    <Currency>Rufiyaa</Currency>\n    <CurrencyCode>MVR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Mali</Name>\n    <CountryCode>ml</CountryCode>\n    <Currency>CFA Franc BCEAO</Currency>\n    <CurrencyCode>XOF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Malta</Name>\n    <CountryCode>mt</CountryCode>\n    <Currency>Lira</Currency>\n    <CurrencyCode>MTL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Marshall Islands</Name>\n    <CountryCode>mh</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Martinique (French)</Name>\n    <CountryCode>mq</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Mauritania</Name>\n    <CountryCode>mr</CountryCode>\n    <Currency>Ouguiya</Currency>\n    <CurrencyCode>MRO</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Mauritius</Name>\n    <CountryCode>mu</CountryCode>\n    <Currency>Rupee</Currency>\n    <CurrencyCode>MUR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Mayotte</Name>\n    <CountryCode>yt</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Mexico</Name>\n    <CountryCode>mx</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>MXP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Micronesia</Name>\n    <CountryCode>fm</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Moldavia</Name>\n    <CountryCode>md</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Monaco</Name>\n    <CountryCode>mc</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Mongolia</Name>\n    <CountryCode>mn</CountryCode>\n    <Currency>Tugrik</Currency>\n    <CurrencyCode>MNT</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Montserrat</Name>\n    <CountryCode>ms</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Morocco</Name>\n    <CountryCode>ma</CountryCode>\n    <Currency>Dirham</Currency>\n    <CurrencyCode>MAD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Mozambique</Name>\n    <CountryCode>mz</CountryCode>\n    <Currency>Metical</Currency>\n    <CurrencyCode>MZM</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Myanmar</Name>\n    <CountryCode>mm</CountryCode>\n    <Currency>Kyat</Currency>\n    <CurrencyCode>MMK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Namibia</Name>\n    <CountryCode>na</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Nauru</Name>\n    <CountryCode>nr</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Nepal</Name>\n    <CountryCode>np</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Netherlands</Name>\n    <CountryCode>nl</CountryCode>\n    <Currency>Guilder</Currency>\n    <CurrencyCode>NLG</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Netherlands Antilles</Name>\n    <CountryCode>an</CountryCode>\n    <Currency>Antillian Guilder</Currency>\n    <CurrencyCode>ANG</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Neutral Zone</Name>\n    <CountryCode>nt</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>New Caledonia (French)</Name>\n    <CountryCode>nc</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>New Zealand</Name>\n    <CountryCode>nz</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>NZD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Nicaragua</Name>\n    <CountryCode>ni</CountryCode>\n    <Currency>Cordoba Oro</Currency>\n    <CurrencyCode>NIO</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Niger</Name>\n    <CountryCode>ne</CountryCode>\n    <Currency>CFA Franc</Currency>\n    <CurrencyCode>XOF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Nigeria</Name>\n    <CountryCode>ng</CountryCode>\n    <Currency>Naira</Currency>\n    <CurrencyCode>NGN</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Niue</Name>\n    <CountryCode>nu</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Norfolk Island</Name>\n    <CountryCode>nf</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>North Korea</Name>\n    <CountryCode>kp</CountryCode>\n    <Currency>Won</Currency>\n    <CurrencyCode>KPW</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Northern Mariana Islands</Name>\n    <CountryCode>mp</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Norway</Name>\n    <CountryCode>no</CountryCode>\n    <Currency>Kroner</Currency>\n    <CurrencyCode>NOK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Oman</Name>\n    <CountryCode>om</CountryCode>\n    <Currency>Rial</Currency>\n    <CurrencyCode>OMR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Pakistan</Name>\n    <CountryCode>pk</CountryCode>\n    <Currency>Rupee</Currency>\n    <CurrencyCode>PKR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Palau</Name>\n    <CountryCode>pw</CountryCode>\n    <Currency>oz</Currency>\n    <CurrencyCode>XPD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Panama</Name>\n    <CountryCode>pa</CountryCode>\n    <Currency>Balboa</Currency>\n    <CurrencyCode>PAB</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Papua New Guinea</Name>\n    <CountryCode>pg</CountryCode>\n    <Currency>Kina</Currency>\n    <CurrencyCode>PGK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Paraguay</Name>\n    <CountryCode>py</CountryCode>\n    <Currency>Guarani</Currency>\n    <CurrencyCode>PYG</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Peru</Name>\n    <CountryCode>pe</CountryCode>\n    <Currency>Neuevo Sol</Currency>\n    <CurrencyCode>PEN</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Philippines</Name>\n    <CountryCode>ph</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>PHP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Pitcairn Island</Name>\n    <CountryCode>pn</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Poland</Name>\n    <CountryCode>pl</CountryCode>\n    <Currency>Zloty</Currency>\n    <CurrencyCode>PLZ</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Polynesia (French)</Name>\n    <CountryCode>pf</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Portugal</Name>\n    <CountryCode>pt</CountryCode>\n    <Currency>Escudo</Currency>\n    <CurrencyCode>PTE</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Puerto Rico</Name>\n    <CountryCode>pr</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Qatar</Name>\n    <CountryCode>qa</CountryCode>\n    <Currency>Rial</Currency>\n    <CurrencyCode>QAR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Reunion (French)</Name>\n    <CountryCode>re</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Romania</Name>\n    <CountryCode>ro</CountryCode>\n    <Currency>Leu</Currency>\n    <CurrencyCode>ROL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Russian Federation</Name>\n    <CountryCode>ru</CountryCode>\n    <Currency>Rouble</Currency>\n    <CurrencyCode>RUB</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Rwanda</Name>\n    <CountryCode>rw</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>S. Georgia &amp; S. Sandwich Isls.</Name>\n    <CountryCode>gs</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Saint Helena</Name>\n    <CountryCode>sh</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Saint Kitts &amp; Nevis Anguilla</Name>\n    <CountryCode>kn</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Saint Lucia</Name>\n    <CountryCode>lc</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Saint Pierre and Miquelon</Name>\n    <CountryCode>pm</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Saint Tome (Sao Tome) and Principe</Name>\n    <CountryCode>st</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Saint Vincent &amp; Grenadines</Name>\n    <CountryCode>vc</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Samoa</Name>\n    <CountryCode>ws</CountryCode>\n    <Currency>Tala</Currency>\n    <CurrencyCode>WST</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>San Marino</Name>\n    <CountryCode>sm</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Saudi Arabia</Name>\n    <CountryCode>sa</CountryCode>\n    <Currency>Riyal</Currency>\n    <CurrencyCode>SAR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Senegal</Name>\n    <CountryCode>sn</CountryCode>\n    <Currency>CFA Franc </Currency>\n    <CurrencyCode>XOF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Seychelles</Name>\n    <CountryCode>sc</CountryCode>\n    <Currency>Rupee</Currency>\n    <CurrencyCode>SCR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Sierra Leone</Name>\n    <CountryCode>sl</CountryCode>\n    <Currency>Leone</Currency>\n    <CurrencyCode>SLL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Singapore</Name>\n    <CountryCode>sg</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>SGD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Slovak Republic</Name>\n    <CountryCode>sk</CountryCode>\n    <Currency>Koruna</Currency>\n    <CurrencyCode>SKK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Slovenia</Name>\n    <CountryCode>si</CountryCode>\n    <Currency>Tolar</Currency>\n    <CurrencyCode>SIT</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Solomon Islands</Name>\n    <CountryCode>sb</CountryCode>\n    <Currency> Dollar</Currency>\n    <CurrencyCode>SBD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Somalia</Name>\n    <CountryCode>so</CountryCode>\n    <Currency>Schilling</Currency>\n    <CurrencyCode>SOS</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>South Africa</Name>\n    <CountryCode>za</CountryCode>\n    <Currency>Rand</Currency>\n    <CurrencyCode>ZAR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>South Korea</Name>\n    <CountryCode>kr</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Spain</Name>\n    <CountryCode>es</CountryCode>\n    <Currency>Peseta</Currency>\n    <CurrencyCode>ESP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Sri Lanka</Name>\n    <CountryCode>lk</CountryCode>\n    <Currency>Rupee</Currency>\n    <CurrencyCode>LKR</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Sudan</Name>\n    <CountryCode>sd</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>SDD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Suriname</Name>\n    <CountryCode>sr</CountryCode>\n    <Currency>Guilder</Currency>\n    <CurrencyCode>SRG</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Svalbard and Jan Mayen Islands</Name>\n    <CountryCode>sj</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Swaziland</Name>\n    <CountryCode>sz</CountryCode>\n    <Currency>Lilangeni</Currency>\n    <CurrencyCode>SZL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Sweden</Name>\n    <CountryCode>se</CountryCode>\n    <Currency>Krona</Currency>\n    <CurrencyCode>SEK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Switzerland</Name>\n    <CountryCode>ch</CountryCode>\n    <Currency>Franc</Currency>\n    <CurrencyCode>CHF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Syria</Name>\n    <CountryCode>sy</CountryCode>\n    <Currency>Pound</Currency>\n    <CurrencyCode>SYP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Tadjikistan</Name>\n    <CountryCode>tj</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Taiwan</Name>\n    <CountryCode>tw</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>TWD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Tanzania</Name>\n    <CountryCode>tz</CountryCode>\n    <Currency>Schilling</Currency>\n    <CurrencyCode>TZS</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Thailand</Name>\n    <CountryCode>th</CountryCode>\n    <Currency>Baht</Currency>\n    <CurrencyCode>THB</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Togo</Name>\n    <CountryCode>tg</CountryCode>\n    <Currency>CFA Franc BCEAO</Currency>\n    <CurrencyCode>XOF</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Tokelau</Name>\n    <CountryCode>tk</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Tonga</Name>\n    <CountryCode>to</CountryCode>\n    <Currency>Pa'anga</Currency>\n    <CurrencyCode>TOP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Trinidad and Tobago</Name>\n    <CountryCode>tt</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>TTD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Tunisia</Name>\n    <CountryCode>tn</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>TND</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Turkey</Name>\n    <CountryCode>tr</CountryCode>\n    <Currency>Lira</Currency>\n    <CurrencyCode>TRL</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Turkmenistan</Name>\n    <CountryCode>tm</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Turks and Caicos Islands</Name>\n    <CountryCode>tc</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Tuvalu</Name>\n    <CountryCode>tv</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Uganda</Name>\n    <CountryCode>ug</CountryCode>\n    <Currency>Schilling</Currency>\n    <CurrencyCode>UGS</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Ukraine</Name>\n    <CountryCode>ua</CountryCode>\n    <Currency>Hryvnia</Currency>\n    <CurrencyCode>UAG</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>United Arab Emirates</Name>\n    <CountryCode>ae</CountryCode>\n    <Currency>Dirham</Currency>\n    <CurrencyCode>AED</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>United Kingdom</Name>\n    <CountryCode>uk</CountryCode>\n    <Currency>Pound</Currency>\n    <CurrencyCode>GBP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>United States</Name>\n    <CountryCode>us</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>USD</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Uruguay</Name>\n    <CountryCode>uy</CountryCode>\n    <Currency>Peso</Currency>\n    <CurrencyCode>UYP</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>USA Minor Outlying Islands</Name>\n    <CountryCode>um</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Uzbekistan</Name>\n    <CountryCode>uz</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Vanuatu</Name>\n    <CountryCode>vu</CountryCode>\n    <Currency>Vatu</Currency>\n    <CurrencyCode>VUV</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Venezuela</Name>\n    <CountryCode>ve</CountryCode>\n    <Currency>Bolivar</Currency>\n    <CurrencyCode>VEB</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Vietnam</Name>\n    <CountryCode>vn</CountryCode>\n    <Currency>Dong</Currency>\n    <CurrencyCode>VND</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Virgin Islands (British)</Name>\n    <CountryCode>vg</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Virgin Islands (USA)</Name>\n    <CountryCode>vi</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Wallis and Futuna Islands</Name>\n    <CountryCode>wf</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Western Sahara</Name>\n    <CountryCode>eh</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Yemen</Name>\n    <CountryCode>ye</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Yugoslavia</Name>\n    <CountryCode>yu</CountryCode>\n    <Currency>Dinar</Currency>\n    <CurrencyCode>YUN</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Zaire</Name>\n    <CountryCode>zr</CountryCode>\n    <Currency />\n    <CurrencyCode />\n  </Table>\n  <Table>\n    <Name>Zambia</Name>\n    <CountryCode>zm</CountryCode>\n    <Currency>Kwacha</Currency>\n    <CurrencyCode>ZMK</CurrencyCode>\n  </Table>\n  <Table>\n    <Name>Zimbabwe</Name>\n    <CountryCode>zw</CountryCode>\n    <Currency>Dollar</Currency>\n    <CurrencyCode>ZWD</CurrencyCode>\n  </Table>\n</NewDataSet>", :xmlns=>"http://www.webserviceX.NET"}}
    end
  end
end
