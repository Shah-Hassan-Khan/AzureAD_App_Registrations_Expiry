# get the list of all app registrations, including enterprise applications
$results = @()
Get-AzureADApplication -All $true | %{  
                             $app = $_
                             $owner = Get-AzureADApplicationOwner -ObjectId $_.ObjectID -Top 1    # Getting Owner info
                             $app.PasswordCredentials | 
                                %{ 
                                    $results += [PSCustomObject] @{
                                            CredentialType = "PasswordCredentials";
                                            DisplayName = $app.DisplayName; 
                                            ExpiryDate = $_.EndDate;
                                            #StartDate = $_.StartDate;
                                            KeyID = $_.KeyId;
                                           # Type = 'NA';
                                           # Usage = 'NA';
                                            Owners = $owner.UserPrincipalName;
                                        }
                                 } 
                                  
                             $app.KeyCredentials | 
                                %{ 
                                    $results += [PSCustomObject] @{
                                            CredentialType = "KeyCredentials";                                        
                                            DisplayName = $app.DisplayName; 
                                            ExpiryDate = $_.EndDate;
                                            #StartDate = $_.StartDate;
                                            KeyID = $_.KeyId;
                                            #Type = $_.Type;
                                           # Usage = $_.Usage;
                                            Owners = $owner.UserPrincipalName;
                                        }
                                 }                            
                          }
$results | FT -AutoSize 
