package RequestDAO;

import model.ScoreRequest;
import java.util.List;

public interface IRequestDAO {
    void insert(ScoreRequest request);
    List<ScoreRequest> findPending(int limit);
    void updateStatus(int id, String status);
    ScoreRequest findById(int id);
} 