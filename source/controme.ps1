$ContromeServerURL = "http://192.168.1.201"

# do not change anything from here
$URL = "$ContromeServerURL/get/json/v1/1/temps"

$ContromeRestRequest = Invoke-RestMethod -Uri $URL
[String] $ScriptDir = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$Controme = $ContromeRestRequest.raeume

$OutArray= @()
foreach ($Item in $Controme) {
    $OutArray +="# " + $Item.name
    $OutArray +="- platform: rest"
    $OutArray +="  name: controme_" + $Item.name.replace(' ','').ToLower() + ""
    $OutArray +="  resource: " + $URL + "/" + $Item.ID + "/"
    $OutArray +="  value_template: '{{ value_json[0][""name""] }}'"
    $OutArray +="  json_attributes:"
    $OutArray +="    - temperatur"
    $OutArray +="    - solltemperatur"
    $OutArray +="    - total_offset"
    $OutArray +="    - offsets"
    $OutArray +="    - sensoren"
    $OutArray +=""
    $OutArray +="- platform: template"
    $OutArray +="  sensors:"
    $OutArray +="    controme_" + $Item.name.replace(' ','').ToLower() + "_solltemperatur:"
    $OutArray +="      friendly_name: '" + $Item.name + " Solltemperatur'"
    $OutArray +="      unit_of_measurement: '°C'"
    $OutArray +="      value_template: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""solltemperatur""] | round(2) }}'"
    $OutArray +=""
    $OutArray +="    controme_" + $Item.name.replace(' ','').ToLower() + "_temperatur:"
    $OutArray +="      friendly_name: '" + $Item.name + " Temperatur'"
    $OutArray +="      unit_of_measurement: '°C'"
    $OutArray +="      value_template: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""temperatur""] | round(2) }}'"
    $OutArray +=""
    $OutArray +="    controme_" + $Item.name.replace(' ','').ToLower() + "_total_offset:"
    $OutArray +="      friendly_name: '" + $Item.name + " Total Offset'"
    $OutArray +="      unit_of_measurement: '°C'"
    $OutArray +="      value_template: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""total_offset""] | round(2) }}'"
    $OutArray +="      attribute_templates:"

    foreach ($offset in $Item.offsets) {
        $OutArray +="          offset_wetter_raum: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Wetter""][""raum""] | round(2) }}'"
        $OutArray +="          offset_wetter_haus: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Wetter""][""haus""] | round(2) }}'"
        $OutArray +="          offset_hfopti_raum: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Heizflächenoptimierung""][""raum""] | round(2) }}'"
        $OutArray +="          offset_hfopti_haus: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Heizflächenoptimierung""][""haus""] | round(2) }}'"
        $OutArray +="          offset_zeitschalter_raum: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Zeitschalter""][""raum""] | round(2) }}'"
        $OutArray +="          offset_zeitschalter_haus: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Zeitschalter""][""haus""] | round(2) }}'"
        $OutArray +="          offset_timer_raum: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Timer""][""raum""] | round(2) }}'"
        $OutArray +="          offset_timer_haus: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Timer""][""haus""] | round(2) }}'"
        $OutArray +="          offset_fensteroffenerkennung_raum: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Fenster-offen-Erkennung""][""raum""] | round(2) }}'"
        $OutArray +="          offset_fensteroffenerkennung_haus: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Fenster-offen-Erkennung""][""haus""] | round(2) }}'"
        $OutArray +="          offset_kalender_raum: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Kalender""][""raum""] | round(2) }}'"
        $OutArray +="          offset_kalender_haus: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Kalender""][""haus""] | round(2) }}'"
        $OutArray +="          offset_außentempkorrektur_raum: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Außentemperaturkorrektur""][""raum""] | round(2) }}'"
        $OutArray +="          offset_außentempkorrektur_haus: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""offsets""][""Außentemperaturkorrektur""][""haus""] | round(2) }}'"
        $OutArray +=""
    }

    $SensorNummer = 0
    foreach ($Sensoren in $Item.sensoren) {
        $OutArray +="    controme_" + $Item.name.replace(' ','').ToLower() + "_sensor_" + $SensorNummer + ":"
        $OutArray +="      friendly_name: '" + $Sensoren.beschreibung + " " + $SensorNummer + "'"
        $OutArray +="      unit_of_measurement: '°C'"
        $OutArray +="      value_template: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""sensoren""][" + $SensorNummer + "][""wert""] | round(2) }}'"
        $OutArray +="      attribute_templates:"
        $OutArray +="        letzte_uebertragung: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""sensoren""][" + $SensorNummer + "][""letzte_uebertragung""] }}'"
        $OutArray +="        name: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""sensoren""][" + $SensorNummer + "][""name""] }}'"
        $OutArray +="        beschreibung: '{{ states.sensor.controme_" + $Item.name.replace(' ','').ToLower() + ".attributes[""sensoren""][" + $SensorNummer + "][""beschreibung""] }}'"
        $OutArray +=""

        $SensorNummer ++
    }
    
}

[System.IO.File]::WriteAllLines("$ScriptDir\controme.yaml", $OutArray)