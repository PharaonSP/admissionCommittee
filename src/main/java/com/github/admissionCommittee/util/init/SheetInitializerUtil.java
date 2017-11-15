package com.github.admissionCommittee.util.init;

import com.github.admissionCommittee.model.Sheet;
import com.github.admissionCommittee.model.Subject;
import com.github.admissionCommittee.model.User;
import com.github.admissionCommittee.service.ServiceFactory;
import com.github.admissionCommittee.service.SheetService;
import com.github.admissionCommittee.util.validate.ValidatorUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.github.admissionCommittee.model.enums.UserTypeEnum.ADMIN;

public class SheetInitializerUtil implements InitializerUtil {
    private static final Logger log = LoggerFactory.getLogger
            (SheetInitializerUtil.class);

    @Override
    public void init(int entitiesNumber, String outputFile,
                     String inputFile) {
        ArrayList<Sheet> sheets = new ArrayList<>();
        List<User> userList = ServiceFactory.getServiceFactory()
                .getUserService().getAll();
        SheetService sheetService = ServiceFactory.getServiceFactory()
                .getSheetService();
        ValidatorUtil validator = ValidatorUtil.getValidator(Sheet
                .class);
        final int[] counter = {0};
        userList.stream().filter(user -> user.getUserRole() != ADMIN).forEach
                (user -> {
                    Sheet sheet = new Sheet(user, user.getFaculty(),
                            calculateScoreSum(user.getSchoolCertificate()
                                    .getSubjects()),
                            calculateScoreSum(
                                    user.getExamCertificate()
                                            .getSubjects()) / user
                                    .getExamCertificate()
                                    .getSubjects()
                                    .size());
                    validator.validate(sheet);
                    sheets.add(sheet);
                    //assign sheet to user
                    user.setSheet(sheet);
                    counter[0]++;
                });
        ServiceFactory.getServiceFactory().getSheetService().save
                (sheets);
        validator.validateInit(sheets);
        //update users
        ServiceFactory.getServiceFactory().getUserService().save(userList);
        log.info(String.format("Sheets have been initialized successfully," +
                " total %d sheets", counter[0]));
    }

    private int calculateScoreSum(Map<Subject, Integer> scoresMap) {
        return scoresMap.keySet().stream().mapToInt(scoresMap::get)
                .sum();
    }
}