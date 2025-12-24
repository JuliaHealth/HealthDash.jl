module VitalsExtension

using Stipple, StippleUI

export vitals_ui

function vitals_ui()
    return htmldiv(class="q-pa-lg", [
        h4("Vitals Dashboard")
        p("Quick overview of patient vitals")
        p(class="text-caption", "Heart Rate: 72 bpm")
        p(class="text-caption", "Blood Pressure: 120/80 mmHg")
        p(class="text-caption", "Temperature: 98.6°F")
        p(class="text-caption", "Respiratory Rate: 16 breaths/min")
    ])
end

end
