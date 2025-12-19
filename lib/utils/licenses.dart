import 'package:flutter/foundation.dart';

class AppLicenses {
  AppLicenses._();

  static void registerQuicksandLicense() {
    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(
        ['Quicksand'],
        // SIL Open Font License (OFL) Version 1.1 for Quicksand.
        '''Copyright 2011 The Quicksand Project Authors (https://github.com/andrew-paglinawan/QuicksandFamily), with Reserved Font Name “Quicksand”.

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
https://openfontlicense.org


-----------------------------------------------------------\n
SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007
-----------------------------------------------------------

PREAMBLE
The goals of the Open Font License (OFL) are to stimulate worldwide
development of collaborative font projects, to support the font creation
efforts of academic and linguistic communities, and to provide a free and
open framework in which fonts may be shared and improved in partnership
with others.

The OFL allows the licensed fonts to be used, studied, modified and
redistributed freely as long as they are not sold by themselves. The
fonts, including any derivative works, can be bundled, embedded, 
redistributed and/or sold with any software provided that any reserved
names are not used by derivative works. The fonts and derivatives,
however, cannot be released under any other type of license. The
requirement for fonts to remain under this license does not apply
to any document created using the fonts or their derivatives.

DEFINITIONS
"Font Software" refers to the set of files released by the Copyright
Holder(s) under this license and clearly marked as such. This may
include source files, build scripts and documentation.

"Reserved Font Name" refers to any names specified as such after the
copyright statement(s).

"Original Version" refers to the collection of Font Software components as
distributed by the Copyright Holder(s).

"Modified Version" refers to any derivative made by adding to, deleting,
or substituting -- in part or in whole -- any of the components of the
Original Version, by changing formats or by porting the Font Software to a
new environment.

"Author" refers to any designer, engineer, programmer, technical
writer or other person who contributed to the Font Software.

PERMISSION & CONDITIONS
Permission is hereby granted, free of charge, to any person obtaining
a copy of the Font Software, to use, study, copy, merge, embed, modify,
redistribute, and sell modified and unmodified copies of the Font
Software, subject to the following conditions:

1) Neither the Font Software nor any of its individual components,
in Original or Modified Versions, may be sold by itself.

2) Original or Modified Versions of the Font Software may be bundled,
redistributed and/or sold with any software, provided that each copy
contains the above copyright notice and this license. These can be
included either as stand-alone text files, human-readable headers or
in the appropriate machine-readable metadata fields within text or
binary files as long as those fields can be easily viewed by the user.

3) No Modified Version of the Font Software may use the Reserved Font
Name(s) unless explicit written permission is granted by the corresponding
Copyright Holder. This restriction only applies to the primary font name as
presented to the users.

4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
Software shall not be used to promote, endorse or advertise any
Modified Version, except to acknowledge the contribution(s) of the
Copyright Holder(s) and the Author(s) or with their explicit written
permission.

5) The Font Software, modified or unmodified, in part or in whole,
must be distributed entirely under this license, and must not be
distributed under any other license. The requirement for fonts to
remain under this license does not apply to any document created
using the Font Software.

TERMINATION
This license becomes null and void if any of the above conditions are
not met.

DISCLAIMER
THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM
OTHER DEALINGS IN THE FONT SOFTWARE.''',
      );
    });
  }

  static void registerGoogleCloudLicense() {
    LicenseRegistry.addLicense(() async* {
      yield const LicenseEntryWithLineBreaks(
        ['Google Cloud Services'],
        '''Google Cloud Terms of Service

These Google Cloud Terms of Service (together, the "Agreement") are entered into by Google and the entity or person agreeing to these terms ("Customer") and govern Customer's access to and use of the Services. "Google" has the meaning given at https://cloud.google.com/terms/google-entity.

This Agreement is effective when Customer clicks to accept or otherwise agrees to it (the "Effective Date"). If you are accepting on behalf of Customer, you represent and warrant that (i) you have full legal authority to bind Customer to this Agreement; (ii) you have read and understand this Agreement; and (iii) you agree, on behalf of Customer, to this Agreement.

1. Provision of the Services.

1.1 Services Use. During the Term, Google will provide the Services in accordance with this Agreement, including the SLAs, and Customer may use the Services, and integrate the GCP Services and Looker (original) Services into any Customer Application that has material value independent of the Services, in accordance with this Agreement. For clarity, Customer may not integrate the Google Workspace Services or SecOps Services into Customer Applications or create or host Customer Applications using the Google Workspace Services or SecOps Services under this Agreement, and Customer may only integrate Looker (original) Services into a Customer Application as provided in the Service Specific Terms.

1.2 Admin Console. If applicable, Customer will have access to the Admin Console, through which Customer may manage its use of the Services.

1.3 Accounts; Verification to Use GWS Services.
(a) Accounts. Customer must have an Account to use the Services and is responsible for the information it provides to create the Account, the security of its passwords for the Account (including any keys for Google APIs) and for any use of its Account. Google has no obligation to provide multiple accounts to Customer.
(b) Verification to use GWS Services. Customer must verify a Domain Email Address or a Domain Name to use GWS Services. If Customer does not have valid permission to use the Domain Email Address or does not own or control the Domain Name, then Google will have no obligation to provide Customer with GWS Services and may delete the Account without notice.

1.4 Updates.
(a) To the Services. Google may make commercially reasonable updates to the Services from time to time.
(b) To this Agreement. Subject to subsections (i) and (ii), Google may make updates to this Agreement from time to time. Google will post any update to this Agreement to https://cloud.google.com/terms/.
(c) To the URL Terms. Google may make commercially reasonable updates to the URL Terms from time to time by posting any such update at the relevant URL Term.
(d) To the Cloud Data Processing Addendum. Google may only update the Cloud Data Processing Addendum where such update is required to comply with applicable law or expressly permitted by the Cloud Data Processing Addendum.
(e) Discontinuation of Services. Google will notify Customer at least 12 months before discontinuing any Service (or associated material functionality).

1.5 Software. If Google makes Software available to Customer, including third-party software, Customer's use of any Software is subject to the applicable provisions in the Service Specific Terms.

2. Payment Terms.

2.1 Billing. Google will issue an electronic bill or invoice to Customer for all Fees. Customer will pay all Fees in the currency stated in the bill or invoice. Unless required by law, Customer's obligation to pay all Fees is non-cancellable.

2.2 Taxes. Customer is responsible for any Taxes, and will pay Google for the Services without any reduction for Taxes.

2.3 Payment Disputes & Refunds. Any payment disputes must be submitted in good faith before the Payment Due Date.

2.4 Delinquent Payments; Suspension. Late payments may bear interest at the rate of 1.5% per month from the Payment Due Date until paid in full.

2.5 No Purchase Order Number Required. Customer is obligated to pay all applicable Fees without any requirement for Google to provide a purchase order number.

2.6 Price Revisions. Google may change the Prices at any time unless otherwise expressly agreed in an addendum or Order Form.

3. Customer Obligations.

3.1 Compliance. Customer will (a) ensure that Customer and its End Users' use of the Services complies with this Agreement, (b) use commercially reasonable efforts to prevent and terminate any unauthorized use of, or access to, the Services.

3.2 Privacy. Customer is responsible for any consents and notices required to permit (a) Customer's use and receipt of the Services and (b) Google's accessing, storing, and processing of data provided by Customer.

3.3 Restrictions. Customer will not, and will not allow End Users to, (a) copy, modify, or create a derivative work of the Services; (b) reverse engineer, decompile, translate, disassemble, or otherwise attempt to extract any or all of the source code of, the Services; (c) sell, resell, sublicense, transfer, or distribute any or all of the Services; or (d) access or use the Services for High Risk Activities or in violation of the AUP.

3.4 Documentation. Google may provide Documentation for Customer's use of the Services.

3.5 Copyright. Google responds to notices of alleged copyright infringement and terminates the Accounts of repeat infringers in appropriate circumstances.

3.6 Third-Party Content Enforcement (for GCP Services). If Customer's primary use of the GCP Services is to host third-party content, Customer will take steps to enforce compliance with the AUP.

4. Suspension.

4.1 AUP Violations. If Google becomes aware that Customer's or any End User's use of the Services violates the AUP, Google will notify Customer and request correction.

4.2 Other Suspension. Google may immediately Suspend use of the Services to protect the Services, comply with law, or address unauthorized access.

5. Intellectual Property Rights; Protection of Customer Data; Feedback.

5.1 Intellectual Property Rights. Customer retains all Intellectual Property Rights in Customer Data and Customer Applications. Google retains all Intellectual Property Rights in the Services and Software.

5.2 Protection of Customer Data. Google will only access, use, and otherwise process Customer Data in accordance with the Cloud Data Processing Addendum.

5.3 Customer Feedback. Google and its Affiliates may use any Feedback provided by Customer without restriction.

6. Technical Support Services.

6.1 By Customer. Customer is responsible for technical support of its Customer Applications and Projects.
6.2 By Google. Subject to payment of applicable support Fees, Google will provide TSS to Customer during the Term in accordance with the TSS Guidelines.

7. Confidential Information.

7.1 Obligations. The recipient will only use the disclosing party's Confidential Information to exercise the recipient's rights and fulfill its obligations under this Agreement.

14. Definitions.
"AUP" means the then-current acceptable use policy for the Services.
"GCP Services" means the Google Cloud Platform services.
"GWS Services" means the Google Workspace services.
"TSS" means the technical support service provided by Google.

15. Regional Modifications. Customer agrees that the modifications described at https://cloud.google.com/terms/regional-modifications apply to the Agreement if Customer’s billing address is in the applicable region.''',
      );
    });
  }
}
