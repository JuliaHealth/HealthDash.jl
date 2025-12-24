module LabsExtension

using Stipple, StippleUI

export labs_ui

function labs_ui()
    return htmldiv(class="q-pa-lg", [
        h4("Labs Report")
        p("Recent lab results summary")
        p(class="text-caption", "WBC: 7.5 K/μL (Normal)")
        p(class="text-caption", "RBC: 5.2 M/μL (Normal)")
        p(class="text-caption", "Hemoglobin: 15.1 g/dL (Normal)")
        p(class="text-caption", "Glucose: 95 mg/dL (Normal)")
    ])
end

end
