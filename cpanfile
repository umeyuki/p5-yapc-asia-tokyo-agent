requires 'Config::Pit';
requires 'Net::Twitter::Lite::WithAPIv1_1';
requires 'Net::OAuth', '0.25';

on development => sub {
    requires "DDP";
};
